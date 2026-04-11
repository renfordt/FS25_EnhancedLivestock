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
            nutrition = "nutrition.xml",
            translations = "translations/translation"
        },
        versionedResources = {
            {
                minVersion = {1, 4},
                resources = {
                    fillTypes = "1.4/fillTypes.xml",
                    animals = "1.4/animals.xml",
                    translations = "1.4/translations/translation"
                }
            }
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

            -- Detect mod version from modDesc.xml
            if g_modNameToDirectory and g_modNameToDirectory[bridge.modName] then
                local modXmlFile = XMLFile.load("tempBridgeModDesc", g_modNameToDirectory[bridge.modName] .. "modDesc.xml")
                if modXmlFile then
                    bridge.version = modXmlFile:getString("modDesc.version", "1.0.0.0")
                    modXmlFile:delete()
                end
            end

            -- Load optional metadata (area code)
            self:loadBridgeMetadata(bridge)

            table.insert(self.bridges, bridge)
            print(string.format("[EL Bridge] Detected and loaded bridge: %s (version %s)", bridge.name, bridge.version or "unknown"))
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

---Pre-resolve $l10n_ references in fill type XML before loading.
---The base game's loadFillTypes resolves $l10n_ using the customEnvironment's
---mod namespace, but bridge-specific translations (drake, gander, alpaca male, etc.)
---are only in the global namespace (set via g_i18n:setText). This function resolves
---them manually so loadFillTypes receives already-resolved title strings.
---@param xmlFileHandle number The XML file handle
---@param bridgeModName string The bridge mod name for mod-namespace lookup
function BridgeRegistry:resolveL10nInFillTypes(xmlFileHandle, bridgeModName)
    local i = 0
    local failedCount = 0
    while true do
        local key = string.format("map.fillTypes.fillType(%d)", i)
        local title = getXMLString(xmlFileHandle, key .. "#title")
        if title == nil then
            break
        end

        if title:sub(1, 6) == "$l10n_" then
            local l10nKey = title:sub(7)
            -- Try bridge mod namespace first (e.g. keys HofBergmann defines itself)
            local resolved = g_i18n:getText(l10nKey, bridgeModName)
            if resolved == l10nKey then
                -- Not found in mod namespace, try global (bridge translations set via setText)
                resolved = g_i18n:getText(l10nKey)
            end
            if resolved ~= l10nKey then
                setXMLString(xmlFileHandle, key .. "#title", resolved)
            else
                local fillTypeName = getXMLString(xmlFileHandle, key .. "#name") or "?"
                print(string.format("[EL Bridge] Warning: Failed to resolve l10n key '%s' for fillType '%s'", l10nKey, fillTypeName))
                failedCount = failedCount + 1
            end
        end
        i = i + 1
    end

    if failedCount > 0 then
        print(string.format("[EL Bridge] Warning: %d l10n key(s) failed to resolve in fill types for %s", failedCount, bridgeModName))
    end
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
                    -- Pre-resolve $l10n_ references so bridge-specific translations
                    -- (which are in global namespace) are found correctly
                    self:resolveL10nInFillTypes(xmlFileHandle, bridge.modName)
                    g_fillTypeManager:loadFillTypes(xmlFileHandle, baseDir, false, bridge.modName)
                    delete(xmlFileHandle)
                else
                    print(string.format("[EL Bridge] Warning: Failed to load XML file: %s", fillTypePath))
                end
            else
                print(string.format("[EL Bridge] Warning: Fill types file not found or no base dir: %s", fillTypePath))
            end
        end

        -- Load versioned fillTypes
        for _, versionedRes in ipairs(self:getMatchedVersionedResources(bridge)) do
            if versionedRes.fillTypes then
                print(string.format("[EL Bridge] Loading versioned fill types: %s", versionedRes.fillTypes))
                self:loadFillTypesFile(bridge, versionedRes.fillTypes)
            end
        end
    end
end

---Load translations from all detected bridges (base + versioned)
function BridgeRegistry:loadBridgeTranslations()
    for _, bridge in ipairs(self.bridges) do
        -- Load base translations
        if bridge.resources.translations then
            print(string.format("[EL Bridge] Loading translations from: %s", bridge.modName))
            if not self:loadTranslationFile(bridge, bridge.resources.translations) then
                print(string.format("[EL Bridge] Warning: No translation file found for bridge '%s'", bridge.modName))
            end
        end

        -- Load versioned translations
        for _, versionedRes in ipairs(self:getMatchedVersionedResources(bridge)) do
            if versionedRes.translations then
                print(string.format("[EL Bridge] Loading versioned translations from: %s", versionedRes.translations))
                self:loadTranslationFile(bridge, versionedRes.translations)
            end
        end
    end
end

---Get versioned resources that match the bridge's detected version
---@param bridge table The bridge object
---@return table matchedResources Array of resource tables that match the version
function BridgeRegistry:getMatchedVersionedResources(bridge)
    local matched = {}
    if not bridge.versionedResources or not bridge.version then
        return matched
    end

    for _, vr in ipairs(bridge.versionedResources) do
        if vr.minVersion and g_bridgeUtils.isVersionAtLeast(bridge.version, vr.minVersion[1], vr.minVersion[2]) then
            table.insert(matched, vr.resources)
        end
    end

    return matched
end

---Load a single translation file using the language fallback chain
---@param bridge table The bridge object
---@param translationBase string Base path for translations (without _lang.xml)
function BridgeRegistry:loadTranslationFile(bridge, translationBase)
    local l10nNames = { g_languageShort, "en", "de" }
    local xmlFile

    for _, l10nName in ipairs(l10nNames) do
        local translationPath = bridge.bridgeDirectory .. translationBase .. "_" .. l10nName .. ".xml"
        xmlFile = XMLFile.loadIfExists("bridgeTranslations", translationPath)
        if xmlFile ~= nil then
            break
        end
    end

    if xmlFile ~= nil then
        xmlFile:iterate("l10n.texts.text", function(_, key)
            local textKey = xmlFile:getString(key .. "#name")
            local textValue = xmlFile:getString(key .. "#text")
            if textKey ~= nil and textValue ~= nil then
                if not g_i18n:hasModText(textKey) then
                    g_i18n:setText(textKey, textValue:gsub("\r\n", "\n"))
                end
            end
        end)
        xmlFile:delete()
        return true
    end

    return false
end

---Load a single fillTypes file
---@param bridge table The bridge object
---@param fillTypesPath string Relative path to fillTypes file within bridge directory
function BridgeRegistry:loadFillTypesFile(bridge, fillTypesPath)
    local fullPath = bridge.bridgeDirectory .. fillTypesPath
    if not fileExists(fullPath) then
        return false
    end

    local baseDir = g_modNameToDirectory and g_modNameToDirectory[bridge.modName]
    if not baseDir then
        return false
    end

    local xmlFileHandle = loadXMLFile("bridgeFillTypes_" .. bridge.modName, fullPath)
    if xmlFileHandle ~= nil then
        self:resolveL10nInFillTypes(xmlFileHandle, bridge.modName)
        g_fillTypeManager:loadFillTypes(xmlFileHandle, baseDir, false, bridge.modName)
        delete(xmlFileHandle)
        return true
    end

    return false
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
