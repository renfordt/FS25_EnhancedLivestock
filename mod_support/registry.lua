---@class BridgeRegistry
---Registry for external mod bridges
BridgeRegistry = {}
BridgeRegistry_mt = Class(BridgeRegistry)

-- Module-level variables (set when file is loaded)
local modDirectory = g_currentModDirectory
local bridgeDirectory = modDirectory .. "mod_support/"

--- Registry of supported bridges with configuration (following RM pattern)
--- Most config is hardcoded, only area code loaded from metadata.xml
BridgeRegistry.SUPPORTED_BRIDGES = {
    {
        modName = "FS25_AnimalPackage_vanillaEdition",
        bridgePath = "FS25_AnimalPackage",
        name = "Animal Package Vanilla Edition",
        priority = 10,
        loadingMode = "replace",
        resources = {
            fillTypes = "$moddir$FS25_AnimalPackage_vanillaEdition/xmls/fillTypes.xml",
            animals = "animals.xml"
        }
    },
    {
        modName = "FS25_HofBergmann",
        bridgePath = "FS25_HofBergmann",
        name = "Hof Bergmann",
        priority = 5,
        loadingMode = "extend",
        resources = {
            fillTypes = "fillTypes.xml",
            animals = "animals.xml",
            nutrition = "nutrition.xml"
        }
    }
}

---Initialize the bridge registry
function BridgeRegistry.new()
    local self = setmetatable({}, BridgeRegistry_mt)

    self.bridges = {}  -- List of detected and loaded bridges

    return self
end

---Detect all installed mods that have bridge support
function BridgeRegistry:detectAll()
    for _, bridgeConfig in ipairs(BridgeRegistry.SUPPORTED_BRIDGES) do
        if g_modIsLoaded and g_modIsLoaded[bridgeConfig.modName] then
            -- Clone the config and add runtime data
            local bridge = {}
            for k, v in pairs(bridgeConfig) do
                bridge[k] = v
            end

            bridge.bridgeDirectory = bridgeDirectory .. bridge.bridgePath .. "/"

            -- Load optional metadata (area code)
            self:loadBridgeMetadata(bridge)

            table.insert(self.bridges, bridge)
            print(string.format("[EL Bridge] Detected and loaded bridge: %s", bridge.name))
        end
    end

    table.sort(self.bridges, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)

    print(string.format("[EL Bridge] Loaded %d bridge(s)", #self.bridges))
end

---Load bridge metadata from metadata.xml
---Only reads area code, all other config is hardcoded (following RM pattern)
---@param bridge table Bridge configuration table
function BridgeRegistry:loadBridgeMetadata(bridge)
    local metadataPath = bridge.bridgeDirectory .. "metadata.xml"
    local xmlFile = XMLFile.load("bridgeMetadata", metadataPath)

    if xmlFile == nil then
        print(string.format("[EL Bridge] No metadata.xml for '%s', using defaults", bridge.name))
        return
    end

    local areaCode = xmlFile:getInt("metadata.map#areaCode")
    if areaCode ~= nil then
        bridge.areaCode = areaCode
        print(string.format("[EL Bridge] '%s' area code set to %d", bridge.name, areaCode))
    end

    xmlFile:delete()
end

---Load fill types from all detected bridges
function BridgeRegistry:loadBridgeFillTypes()
    for _, bridge in ipairs(self.bridges) do
        if bridge.resources.fillTypes then
            local fillTypePath = bridge.resources.fillTypes
            local baseDir

            -- Support $moddir$ references for loading from external mod directories
            if fillTypePath:match("^%$moddir%$") then
                -- Extract mod name to get its directory
                local modMatch = fillTypePath:match("^%$moddir%$([^/]+)/")
                if modMatch then
                    baseDir = g_modNameToDirectory and g_modNameToDirectory[modMatch]
                end
                fillTypePath = g_bridgeUtils.resolveModdirPath(fillTypePath)
            else
                -- Local file in bridge directory
                baseDir = bridge.bridgeDirectory
                fillTypePath = bridge.bridgeDirectory .. fillTypePath
            end

            if fileExists(fillTypePath) and baseDir then
                print(string.format("[EL Bridge] Loading fill types from: %s", bridge.modName))
                -- loadFillTypes expects an XML file HANDLE, not a path
                local xmlFileHandle = loadXMLFile("bridgeFillTypes_" .. bridge.modName, fillTypePath)
                if xmlFileHandle ~= nil then
                    g_fillTypeManager:loadFillTypes(xmlFileHandle, baseDir, false, bridge.modName)
                    delete(xmlFileHandle)
                else
                    print(string.format("[EL Bridge] Warning: Failed to load XML file: %s", fillTypePath))
                end
            else
                print(string.format("[EL Bridge] Warning: Fill types file not found or no base dir: %s", fillTypePath))
            end
        end
    end
end

---Load translations from all detected bridges
function BridgeRegistry:loadBridgeTranslations()
    for _, bridge in ipairs(self.bridges) do
        if bridge.resources.translations then
            local translationPattern = bridge.resources.translations:gsub("{LANG}", g_languageShort)
            local translationPath = bridge.bridgeDirectory .. translationPattern

            if fileExists(translationPath) then
                print(string.format("[EL Bridge] Loading translations from: %s", bridge.modName))
                local xmlFile = XMLFile.loadIfExists("bridgeTranslations", translationPath)
                if xmlFile then
                    -- Load translations into global i18n
                    xmlFile:iterate("l10n.texts.text", function(index, key)
                        local textKey = xmlFile:getValue(key .. "#name")
                        local textValue = xmlFile:getValue(key, "")
                        if textKey and textValue then
                            g_i18n.texts[textKey] = textValue
                        end
                    end)
                    xmlFile:delete()
                end
            end
        end
    end
end

---Validate all animals after loading is complete
---Generates defaults for missing data and logs warnings
---@param animalSystem table The AnimalSystem instance
function BridgeRegistry:validateAnimals(animalSystem)
    if not g_bridgeUtils then
        print("[EL Bridge] Warning: BridgeUtils not loaded, skipping validation")
        return
    end

    local warnings = 0

    for typeName, animalType in pairs(animalSystem.types) do
        for _, subTypeIndex in ipairs(animalType.subTypes) do
            local subType = animalSystem.subTypes[subTypeIndex]
            if subType then
                -- Validate weights
                if not subType.minWeight or not subType.targetWeight or not subType.maxWeight then
                    if subType.navMeshAgent then
                        local generated = g_bridgeUtils.generateWeightDefaults(subType, animalType)
                        if generated then
                            subType.minWeight = subType.minWeight or generated.minWeight
                            subType.targetWeight = subType.targetWeight or generated.targetWeight
                            subType.maxWeight = subType.maxWeight or generated.maxWeight
                            print(string.format("[EL Bridge] Generated weight defaults for %s/%s", typeName, subType.subTypeName))
                            warnings = warnings + 1
                        end
                    else
                        print(string.format("[EL Bridge] Warning: Missing weights and navMesh for %s/%s", typeName, subType.subTypeName))
                        warnings = warnings + 1
                    end
                end

                -- Validate weights are in correct order
                if subType.minWeight and subType.targetWeight and subType.maxWeight then
                    if not (subType.minWeight <= subType.targetWeight and subType.targetWeight <= subType.maxWeight) then
                        print(string.format("[EL Bridge] Warning: Invalid weight order for %s/%s: min=%.1f target=%.1f max=%.1f",
                            typeName, subType.subTypeName, subType.minWeight, subType.targetWeight, subType.maxWeight))
                        warnings = warnings + 1
                    end
                end
            else
                print(string.format("[EL Bridge] Warning: Invalid subType index %d for type %s", subTypeIndex, typeName))
                warnings = warnings + 1
            end
        end

        -- Check nutrition profiles for species
        if g_nutritionManager then
            local hasNutrition = false
            for _, stage in ipairs(g_nutritionManager.lifeStages) do
                if stage.species == typeName then
                    hasNutrition = true
                    break
                end
            end

            if not hasNutrition then
                -- Try to generate nutrition defaults
                local fallbackSpecies = g_bridgeUtils.generateNutritionDefaults(typeName)
                if fallbackSpecies then
                    print(string.format("[EL Bridge] Species %s using nutrition fallback: %s", typeName, fallbackSpecies))
                else
                    print(string.format("[EL Bridge] Warning: No nutrition profile for species: %s", typeName))
                    warnings = warnings + 1
                end
            end
        end
    end

    if warnings > 0 then
        print(string.format("[EL Bridge] Validation complete: %d warning(s)", warnings))
    else
        print("[EL Bridge] Validation complete: all animals OK")
    end
end

---Get all active bridges sorted by priority
---@return table List of bridge objects
function BridgeRegistry:getBridges()
    return self.bridges
end

---Get a specific bridge by mod name
---@param modName string The mod name to search for
---@return table|nil bridge The bridge object or nil if not found
function BridgeRegistry:getBridge(modName)
    for _, bridge in ipairs(self.bridges) do
        if bridge.modName == modName then
            return bridge
        end
    end
    return nil
end
