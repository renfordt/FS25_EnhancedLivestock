---@class BridgeUtils
---Utility functions for bridge support
BridgeUtils = {}

---Generate default weight values from navMesh dimensions
---@param subType table The animal subtype
---@param animalType table The animal type
---@return table|nil weights Table with minWeight, targetWeight, maxWeight or nil if cannot generate
function BridgeUtils.generateWeightDefaults(subType, animalType)
    if not subType.navMeshAgent then
        return nil
    end

    local height = subType.navMeshAgent.height or 1.0
    local radius = subType.navMeshAgent.radius or 0.5
    local densityFactor = 300  -- kg per cubic meter approximation

    -- Calculate approximate volume and mass
    local volume = math.pi * radius * radius * height
    local targetWeight = volume * densityFactor

    return {
        minWeight = targetWeight * 0.15,  -- Baby animals
        targetWeight = targetWeight,
        maxWeight = targetWeight * 1.5    -- Obese animals
    }
end

---Generate balanced genetics for an animal
---Used as fallback when genetics are not specified
---@param farmQuality number Optional farm quality factor (0.0-1.0)
---@return table genetics Table with health, fertility, metabolism, quality, productivity
function BridgeUtils.generateGeneticsDefaults(farmQuality)
    farmQuality = farmQuality or 0.5

    -- Base range: 0.8-1.2, adjusted by farm quality
    local function randomGenetic()
        local base = 0.8 + math.random() * 0.4
        -- Farm quality shifts the range slightly
        return math.clamp(base + (farmQuality - 0.5) * 0.2, 0.25, 1.75)
    end

    return {
        health = randomGenetic(),
        fertility = randomGenetic(),
        metabolism = randomGenetic(),
        quality = randomGenetic(),
        productivity = randomGenetic()
    }
end

---Find a similar species for nutrition profile fallback
---@param speciesName string The species to find fallback for
---@return string|nil fallbackSpecies The fallback species name or nil if none found
function BridgeUtils.generateNutritionDefaults(speciesName)
    local fallbackMap = {
        DUCK = "CHICKEN",
        DUCKWILD = "CHICKEN",
        GOOSE = "CHICKEN",
        RABBIT = "SHEEP",
        BULL = "COW",
        QUAIL = "CHICKEN",
        ALPACA = "SHEEP",
        DOG = "PIG",
        -- CAT has no fallback - would need custom nutrition
    }

    return fallbackMap[speciesName]
end

---Resolve $moddir$ references in paths
---@param path string Path with $moddir$ prefix
---@return string resolvedPath Absolute path or original if no $moddir$
function BridgeUtils.resolveModdirPath(path)
    if not path then
        return nil
    end

    -- Pattern: $moddir$ModName/rest/of/path
    local modName, restPath = path:match("^%$moddir%$([^/]+)/(.*)$")
    if modName and restPath then
        -- Use g_modNameToDirectory which is simpler and always available
        local modDir = g_modNameToDirectory and g_modNameToDirectory[modName]
        if modDir then
            return modDir .. restPath
        else
            print(string.format("[EL Bridge] Warning: Mod not found for path: %s", path))
            return path
        end
    end

    return path
end

---Merge two tables deeply, with values from source taking precedence
---@param target table The target table to merge into
---@param source table The source table to merge from
---@return table merged The merged table (modifies target in place)
function BridgeUtils.deepMerge(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" and type(target[key]) == "table" then
            BridgeUtils.deepMerge(target[key], value)
        else
            target[key] = value
        end
    end
    return target
end

---Clone a table deeply
---@param original table The table to clone
---@return table clone The cloned table
function BridgeUtils.deepClone(original)
    if type(original) ~= "table" then
        return original
    end

    local clone = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            clone[key] = BridgeUtils.deepClone(value)
        else
            clone[key] = value
        end
    end

    return clone
end

---Parse a space-separated list of animal types
---@param animalString string Space-separated animal types (e.g., "COW PIG SHEEP")
---@return table animalTypes Array of animal type strings
function BridgeUtils.parseAnimalTypes(animalString)
    if not animalString or animalString == "" then
        return {}
    end

    local types = {}
    for typeName in animalString:gmatch("%S+") do
        table.insert(types, typeName)
    end
    return types
end

---Check if a fill type exists in the fill type manager
---@param fillTypeName string The fill type name to check
---@return boolean exists True if the fill type exists
function BridgeUtils.fillTypeExists(fillTypeName)
    if not fillTypeName then
        return false
    end

    local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
    return fillTypeIndex ~= nil
end

---Validate required fields in a table
---@param data table The data table to validate
---@param requiredFields table Array of required field names
---@param context string Context string for error messages
---@return boolean valid True if all required fields present
---@return string|nil error Error message if validation failed
function BridgeUtils.validateRequiredFields(data, requiredFields, context)
    for _, fieldName in ipairs(requiredFields) do
        if data[fieldName] == nil then
            return false, string.format("%s: missing required field '%s'", context, fieldName)
        end
    end
    return true
end

---Check if a version string meets a minimum major.minor requirement
---@param version string Version string (e.g., "1.4.0.0 Beta2")
---@param minMajor number Minimum major version
---@param minMinor number Minimum minor version
---@return boolean True if version >= minMajor.minMinor
function BridgeUtils.isVersionAtLeast(version, minMajor, minMinor)
    local parts = string.split(version or "0.0.0.0", ".")
    local major = tonumber(parts[1]) or 0
    local minor = tonumber(parts[2]) or 0
    return major > minMajor or (major == minMajor and minor >= minMinor)
end

-- Initialize global singleton
g_bridgeUtils = BridgeUtils
