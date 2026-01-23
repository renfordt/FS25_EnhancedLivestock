---
-- EL_EPPButcherIntegration
-- Integration module for ExtendedProductionPoint (EPP) butcher mods.
--
-- When an EL animal is delivered to an EPP butcher, this integration:
-- 1. Intercepts the animal before EPP's normal cluster processing
-- 2. Calculates an "animal equivalent" based on weight, quality, and health
-- 3. Stores this fractional value as the INTERMEDIATE fill type (e.g., BEEF, PIGS)
-- 4. The butcher's production chain then converts this to final meat
--
-- This approach allows EL's variable animal values (weight, quality, health)
-- to integrate naturally with EPP's production system while remaining fully
-- compatible with vanilla FS25 and butcher mods designed for vanilla animals.
--
-- Example: A 600kg cow with quality 1.0 and 100% health vs 500kg reference:
--   animal_equivalent = (600/500) * 1.0 * 1.0 = 1.2
--   -> 1.2 BEEF stored in butcher -> production converts to 1.2x normal meat
---

-- Capture mod directory at load time (g_currentModDirectory is only valid during script loading)
local modDirectory = g_currentModDirectory

EL_EPPButcherIntegration = {}

-- Tables will be populated lazily when AnimalType is available
EL_EPPButcherIntegration.MEAT_YIELD = nil
EL_EPPButcherIntegration.FILL_TYPE_MAPPING = nil
EL_EPPButcherIntegration.REFERENCE_WEIGHT = nil  -- Reference weights for "standard" animals

-- Tracks which production points have been hooked
EL_EPPButcherIntegration.hookedProductionPoints = {}

-- Specialization names found in the game
EL_EPPButcherIntegration.eppSpecNames = {}

-- Whether initialization was successful
EL_EPPButcherIntegration.initialized = false

-- Whether the deferred placeable scan has been completed
EL_EPPButcherIntegration.placeablesScanCompleted = false


---
-- Initialize default mappings (called lazily when AnimalType is available)
---
function EL_EPPButcherIntegration.initializeDefaults()
    if AnimalType == nil then
        return -- Cannot initialize yet
    end

    if EL_EPPButcherIntegration.MEAT_YIELD ~= nil and next(EL_EPPButcherIntegration.MEAT_YIELD) ~= nil then
        return  -- Already initialized
    end

    -- Default meat yield percentages by animal type (carcass yield)
    -- Used for calculating "animal equivalent" value
    EL_EPPButcherIntegration.MEAT_YIELD = {}
    if AnimalType ~= nil then
        if AnimalType.COW ~= nil then EL_EPPButcherIntegration.MEAT_YIELD[AnimalType.COW] = 0.60 end
        if AnimalType.PIG ~= nil then EL_EPPButcherIntegration.MEAT_YIELD[AnimalType.PIG] = 0.72 end
        if AnimalType.SHEEP ~= nil then EL_EPPButcherIntegration.MEAT_YIELD[AnimalType.SHEEP] = 0.50 end
        if AnimalType.CHICKEN ~= nil then EL_EPPButcherIntegration.MEAT_YIELD[AnimalType.CHICKEN] = 0.65 end
        if AnimalType.HORSE ~= nil then EL_EPPButcherIntegration.MEAT_YIELD[AnimalType.HORSE] = 0.55 end
    end

    -- Default animal type to INTERMEDIATE fill type mapping (used by EPP butchers)
    -- These are the input fill types that EPP's production chain converts to final meat
    -- E.g., BEEF is stored as input, then production converts BEEF -> MEAT
    EL_EPPButcherIntegration.FILL_TYPE_MAPPING = {}
    if AnimalType ~= nil then
        if AnimalType.COW ~= nil then EL_EPPButcherIntegration.FILL_TYPE_MAPPING[AnimalType.COW] = "BEEF" end
        if AnimalType.PIG ~= nil then EL_EPPButcherIntegration.FILL_TYPE_MAPPING[AnimalType.PIG] = "PIGS" end
        if AnimalType.SHEEP ~= nil then EL_EPPButcherIntegration.FILL_TYPE_MAPPING[AnimalType.SHEEP] = "SHEEPGOAT" end
        if AnimalType.CHICKEN ~= nil then EL_EPPButcherIntegration.FILL_TYPE_MAPPING[AnimalType.CHICKEN] = "POULTRY" end
        if AnimalType.HORSE ~= nil then EL_EPPButcherIntegration.FILL_TYPE_MAPPING[AnimalType.HORSE] = "HORSEMEAT" end
    end

    -- Reference weights for "standard" animals (in kg)
    -- These represent a typical adult animal of average quality
    -- Used to calculate "animal equivalent" value relative to standard
    EL_EPPButcherIntegration.REFERENCE_WEIGHT = {}
    if AnimalType ~= nil then
        if AnimalType.COW ~= nil then EL_EPPButcherIntegration.REFERENCE_WEIGHT[AnimalType.COW] = 500 end      -- 500 kg standard cow
        if AnimalType.PIG ~= nil then EL_EPPButcherIntegration.REFERENCE_WEIGHT[AnimalType.PIG] = 110 end      -- 110 kg standard pig
        if AnimalType.SHEEP ~= nil then EL_EPPButcherIntegration.REFERENCE_WEIGHT[AnimalType.SHEEP] = 45 end   -- 45 kg standard sheep
        if AnimalType.CHICKEN ~= nil then EL_EPPButcherIntegration.REFERENCE_WEIGHT[AnimalType.CHICKEN] = 2.5 end -- 2.5 kg standard chicken
        if AnimalType.HORSE ~= nil then EL_EPPButcherIntegration.REFERENCE_WEIGHT[AnimalType.HORSE] = 500 end  -- 500 kg standard horse
    end

    Logging.info("[EL-EPP] Initialized default mappings (yields, fill types, reference weights)")
end


---
-- Initialize the EPP butcher integration.
-- Called from EnhancedLivestock.loadMap()
---
function EL_EPPButcherIntegration.initialize()
    Logging.info("[EL-EPP] Initializing EPP butcher integration...")

    -- Hook Placeable.finalizePlacement (not onFinalizePlacement!) to detect when placeables are placed.
    -- FS25's specialization system calls event listeners directly via SpecializationUtil.raiseEvent,
    -- bypassing the base class onFinalizePlacement method. So we hook finalizePlacement() which is
    -- the actual function that triggers the event system.
    if not EL_EPPButcherIntegration.globalPlaceableHooked then
        if Placeable.finalizePlacement ~= nil then
            Placeable.finalizePlacement = Utils.appendedFunction(
                Placeable.finalizePlacement,
                EL_EPPButcherIntegration.onPlaceableFinalized
            )
            EL_EPPButcherIntegration.globalPlaceableHooked = true
            Logging.info("[EL-EPP] Hooked Placeable.finalizePlacement for EPP detection")
        else
            -- Fallback: try onFinalizePlacement (may not work for all placeables)
            Placeable.onFinalizePlacement = Utils.appendedFunction(
                Placeable.onFinalizePlacement,
                EL_EPPButcherIntegration.onPlaceableFinalized
            )
            EL_EPPButcherIntegration.globalPlaceableHooked = true
            Logging.info("[EL-EPP] Hooked Placeable.onFinalizePlacement for EPP detection (fallback)")
        end
    end

    -- Try to initialize now (may fail if EPP mod isn't loaded yet)
    local success = EL_EPPButcherIntegration.tryInitialize()

    -- Define deferred scan function
    local deferredScan = function(hookName)
        return function(...)
            if not EL_EPPButcherIntegration.placeablesScanCompleted then
                Logging.info("[EL-EPP] Running deferred placeable scan (triggered by %s)...", hookName)
                EL_EPPButcherIntegration.scanExistingPlaceables()
                EL_EPPButcherIntegration.placeablesScanCompleted = true
            end
        end
    end

    -- Hook multiple points for reliability - different FS25 versions and scenarios
    -- may call these at different times
    local hooked = false

    -- Method 1: Hook BaseMission.onStartMission (called when mission starts, after everything is loaded)
    if BaseMission ~= nil and BaseMission.onStartMission ~= nil then
        BaseMission.onStartMission = Utils.appendedFunction(BaseMission.onStartMission, deferredScan("BaseMission.onStartMission"))
        Logging.info("[EL-EPP] Hooked BaseMission.onStartMission for deferred scan")
        hooked = true
    end

    -- Method 2: Hook FSBaseMission.onStartMission
    if FSBaseMission ~= nil and FSBaseMission.onStartMission ~= nil then
        FSBaseMission.onStartMission = Utils.appendedFunction(FSBaseMission.onStartMission, deferredScan("FSBaseMission.onStartMission"))
        Logging.info("[EL-EPP] Hooked FSBaseMission.onStartMission for deferred scan")
        hooked = true
    end

    -- Method 3: Hook Mission00.loadMission00Finished
    if Mission00 ~= nil and Mission00.loadMission00Finished ~= nil then
        Mission00.loadMission00Finished = Utils.appendedFunction(Mission00.loadMission00Finished, deferredScan("Mission00.loadMission00Finished"))
        Logging.info("[EL-EPP] Hooked Mission00.loadMission00Finished for deferred scan")
        hooked = true
    end

    -- Method 4: Hook g_currentMission.loadMapFinished (if available)
    if g_currentMission ~= nil and g_currentMission.loadMapFinished ~= nil then
        g_currentMission.loadMapFinished = Utils.appendedFunction(g_currentMission.loadMapFinished, deferredScan("g_currentMission.loadMapFinished"))
        Logging.info("[EL-EPP] Hooked g_currentMission.loadMapFinished for deferred scan")
        hooked = true
    end

    if not hooked then
        Logging.warning("[EL-EPP] Could not hook any mission lifecycle events - existing EPP placeables may not be auto-detected")
        Logging.warning("[EL-EPP] EPP placeables will still be detected when newly placed via onPlaceableFinalized hook")
    end

    if success then
        Logging.info("[EL-EPP] Initial integration setup complete")
    else
        Logging.info("[EL-EPP] EPP not detected yet - will scan for placeables after mission starts")
    end
end


---
-- Scan existing placeables for EPP buildings.
-- Called after map load to detect EPP buildings that were placed before our hook was installed.
-- This is important for save games with existing EPP butcher buildings.
---
function EL_EPPButcherIntegration.scanExistingPlaceables()
    Logging.info("[EL-EPP] Scanning existing placeables for EPP buildings...")

    if g_currentMission == nil then
        Logging.info("[EL-EPP] g_currentMission not available, skipping scan")
        return
    end

    if g_currentMission.placeableSystem == nil then
        Logging.info("[EL-EPP] placeableSystem not available, skipping scan")
        return
    end

    local placeables = g_currentMission.placeableSystem.placeables
    if placeables == nil or next(placeables) == nil then
        Logging.info("[EL-EPP] No placeables found in mission")
        return
    end

    local totalCount = 0
    local eppCount = 0

    for _, placeable in pairs(placeables) do
        totalCount = totalCount + 1

        -- Check if this placeable has any EPP-related specs
        local hasEPP = false
        local specFound = nil

        -- Check for the convenience reference (added by EPP at line 164 of PlaceableExtendedProductionPoint.lua)
        if placeable.spec_extendedProductionPoint ~= nil then
            hasEPP = true
            specFound = "spec_extendedProductionPoint"
        end

        -- Check for dynamic spec names like spec_FS25_Butcher.extendedProductionPoint
        if not hasEPP then
            for key, value in pairs(placeable) do
                if type(key) == "string" and type(value) == "table" then
                    if key:match("^spec_.*[.:]extendedProductionPoint$") or key:match("^spec_.*extendedproductionpoint$") then
                        hasEPP = true
                        specFound = key
                        break
                    end
                end
            end
        end

        if hasEPP then
            eppCount = eppCount + 1
            local placeableName = placeable.getName and placeable:getName() or placeable.configFileName or "unknown"
            Logging.info("[EL-EPP] Found existing EPP placeable #%d: %s (spec: %s)", eppCount, placeableName, specFound or "unknown")

            -- Process with onPlaceableFinalized to hook it
            EL_EPPButcherIntegration.onPlaceableFinalized(placeable)
        end
    end

    Logging.info("[EL-EPP] Scan complete: %d total placeables, %d EPP placeables found", totalCount, eppCount)
end


---
-- Attempt to initialize the integration.
-- @return boolean True if initialization was successful
---
function EL_EPPButcherIntegration.tryInitialize()
    if EL_EPPButcherIntegration.initialized then
        return true
    end

    Logging.info("[EL-EPP] tryInitialize called")

    -- Initialize default mappings now that AnimalType should be available
    EL_EPPButcherIntegration.initializeDefaults()

    -- EPP is embedded in other mods (e.g., FS25_Butcher), not standalone.
    -- Due to Lua environment isolation between mods, we cannot directly access
    -- EPP classes from other mods.
    --
    -- IMPORTANT: g_specializationManager/ contains VEHICLE specializations only!
    -- Placeable specializations like EPP are managed differently via the type system.
    -- We cannot reliably detect EPP before placeables are loaded.
    --
    -- Strategy: Check if any mod that might contain EPP is loaded, then pre-populate
    -- common EPP spec name patterns for lazy detection.

    -- Check loaded mods for EPP-related mods
    local eppModsFound = {}
    EL_EPPButcherIntegration.eppSpecNames = {}

    if g_modManager ~= nil then
        local mods = g_modManager:getActiveMods() or g_modManager.mods or {}
        for _, mod in pairs(mods) do
            local modName = mod.modName or mod.name or ""
            local modNameLower = modName:lower()

            -- Check for common EPP mod naming patterns
            local isEPPMod = modNameLower:find("butcher") ~= nil
                          or modNameLower:find("slaughter") ~= nil
                          or modNameLower:find("extendedproduction") ~= nil
                          or modNameLower:find("meat") ~= nil
                          or modNameLower:find("meatprocessing") ~= nil
                          or modNameLower:find("abattoir") ~= nil

            if isEPPMod then
                table.insert(eppModsFound, modName)

                -- Pre-populate expected EPP spec names for this mod
                local specName = "spec_" .. modName .. ".extendedProductionPoint"
                if not EL_EPPButcherIntegration.hasSpecName(specName) then
                    table.insert(EL_EPPButcherIntegration.eppSpecNames, specName)
                    Logging.info("[EL-EPP] Pre-registered EPP spec pattern for mod '%s': %s", modName, specName)
                end
            end
        end

        if #eppModsFound > 0 then
            Logging.info("[EL-EPP] Found %d potential EPP mods: %s", #eppModsFound, table.concat(eppModsFound, ", "))
        else
            Logging.info("[EL-EPP] No EPP-related mods detected by name pattern")
        end
    else
        Logging.info("[EL-EPP] g_modManager not available, cannot scan for EPP mods")
    end

    -- Also add the standard spec_extendedProductionPoint pattern (convenience reference added by EPP)
    if not EL_EPPButcherIntegration.hasSpecName("spec_extendedProductionPoint") then
        table.insert(EL_EPPButcherIntegration.eppSpecNames, "spec_extendedProductionPoint")
    end

    -- Load configuration from XML
    EL_EPPButcherIntegration.loadMappingsFromXML()

    -- Mark as initialized - we'll detect and hook EPP placeables via onPlaceableFinalized
    -- Even if no EPP mods were found by name, they might be present with different names
    EL_EPPButcherIntegration.initialized = true

    Logging.info("[EL-EPP] Integration initialized - will detect EPP placeables via onPlaceableFinalized hook")
    Logging.info("[EL-EPP] Pre-registered %d EPP spec name patterns", #EL_EPPButcherIntegration.eppSpecNames)

    return true
end


---
-- Check if a specialization name is already in the list.
---
function EL_EPPButcherIntegration.hasSpecName(specName)
    for _, name in ipairs(EL_EPPButcherIntegration.eppSpecNames) do
        if name == specName then
            return true
        end
    end
    return false
end


---
-- Load meat yield, fill type, and reference weight mappings from XML configuration.
---
function EL_EPPButcherIntegration.loadMappingsFromXML()
    local xmlPath = modDirectory .. "xml/eppMappings.xml"
    local xmlFile = XMLFile.load("eppMappings", xmlPath)

    if xmlFile == nil then
        Logging.warning("[EL-EPP] Could not load eppMappings.xml, using defaults")
        return
    end

    -- Load yields
    xmlFile:iterate("eppMappings.yields.yield", function(_, key)
        local animalTypeName = xmlFile:getString(key .. "#animalType")
        local percentage = xmlFile:getFloat(key .. "#percentage")

        if animalTypeName ~= nil and percentage ~= nil and AnimalType ~= nil then
            local animalType = AnimalType[animalTypeName]
            if animalType ~= nil then
                EL_EPPButcherIntegration.MEAT_YIELD[animalType] = percentage
                Logging.info("[EL-EPP] Loaded yield for %s: %.0f%%", animalTypeName, percentage * 100)
            end
        end
    end)

    -- Load fill type mappings (intermediate types like BEEF, PIGS, etc.)
    xmlFile:iterate("eppMappings.fillTypes.fillType", function(_, key)
        local animalTypeName = xmlFile:getString(key .. "#animalType")
        local fillTypeName = xmlFile:getString(key .. "#name")

        if animalTypeName ~= nil and fillTypeName ~= nil and AnimalType ~= nil then
            local animalType = AnimalType[animalTypeName]
            if animalType ~= nil then
                EL_EPPButcherIntegration.FILL_TYPE_MAPPING[animalType] = fillTypeName
                Logging.info("[EL-EPP] Loaded fill type for %s: %s", animalTypeName, fillTypeName)
            end
        end
    end)

    -- Load reference weights (for calculating animal equivalents)
    xmlFile:iterate("eppMappings.referenceWeights.weight", function(_, key)
        local animalTypeName = xmlFile:getString(key .. "#animalType")
        local weightKg = xmlFile:getFloat(key .. "#kg")

        if animalTypeName ~= nil and weightKg ~= nil and AnimalType ~= nil then
            local animalType = AnimalType[animalTypeName]
            if animalType ~= nil then
                EL_EPPButcherIntegration.REFERENCE_WEIGHT[animalType] = weightKg
                Logging.info("[EL-EPP] Loaded reference weight for %s: %.1f kg", animalTypeName, weightKg)
            end
        end
    end)

    xmlFile:delete()
    Logging.info("[EL-EPP] Configuration loaded from eppMappings.xml")
end


---
-- Hook called when an ExtendedProductionPoint loads.
-- @param superFunc The original function
-- @param ... Additional arguments
-- @return boolean Success status from original function
---
function EL_EPPButcherIntegration.onExtendedProductionPointLoad(productionPoint, superFunc, ...)
    local success = superFunc(productionPoint, ...)

    if success then
        -- Check if this production point accepts animals
        EL_EPPButcherIntegration.checkAndHookProductionPoint(productionPoint)
    end

    return success
end


---
-- Hook called when an animal trigger callback is executed on an EPP production point.
-- Handles EL individual animals by processing them and returning false to EPP to prevent double-processing.
---
function EL_EPPButcherIntegration.onAnimalTriggerCallback(productionPoint, superFunc, trigger, animal, isLeaving, ...)
    if isLeaving then
        return superFunc(productionPoint, trigger, animal, isLeaving, ...)
    end

    -- Check if this is an EL individual animal
    if EL_EPPButcherIntegration.isELAnimal(animal) then
        Logging.info("[EL-EPP] Intercepted EL animal in onAnimalTriggerCallback")
        EL_EPPButcherIntegration.processELAnimal(productionPoint, animal, trigger.source)
        return false -- Return false to stop EPP from processing it as a cluster
    end

    return superFunc(productionPoint, trigger, animal, isLeaving, ...)
end


---
-- Hook called when ANY placeable is finalized (hooked on base Placeable class).
-- Detects EPP placeables and hooks their production points for EL animal processing.
-- @param placeable The placeable object
---
function EL_EPPButcherIntegration.onPlaceableFinalized(placeable)
    if placeable == nil then
        return
    end

    -- Debug: Log all placeable finalizations to verify hook is working
    -- local placeableNameDebug = placeable.getName and placeable:getName() or placeable.configFileName or "unknown"
    -- Logging.info("[EL-EPP] onPlaceableFinalized triggered for: %s", placeableNameDebug)

    -- Find all EPP-related specs on this placeable
    local foundEPPSpecs = {}

    -- Method 1: Check for the convenience reference (added by EPP at line 164 of PlaceableExtendedProductionPoint.lua)
    if placeable.spec_extendedProductionPoint ~= nil then
        table.insert(foundEPPSpecs, {name = "spec_extendedProductionPoint", spec = placeable.spec_extendedProductionPoint})
    end

    -- Method 2: Search for dynamic spec names like "spec_FS25_Butcher.extendedProductionPoint"
    for key, value in pairs(placeable) do
        if type(key) == "string" and type(value) == "table" then
            -- Match patterns: spec_ModName.extendedProductionPoint or spec_extendedProductionPoint
            if key:match("^spec_.*[.:]extendedProductionPoint$") or key:match("^spec_.*extendedproductionpoint$") then
                -- Avoid duplicates
                local isDuplicate = false
                for _, found in ipairs(foundEPPSpecs) do
                    if found.name == key then
                        isDuplicate = true
                        break
                    end
                end
                if not isDuplicate then
                    table.insert(foundEPPSpecs, {name = key, spec = value})
                end
            end
        end
    end

    -- If no EPP specs found, this is not an EPP placeable
    if #foundEPPSpecs == 0 then
        return
    end

    -- We found EPP! Log and initialize if needed
    local placeableName = placeable.getName and placeable:getName() or placeable.configFileName or "unknown"
    Logging.info("[EL-EPP] Detected EPP placeable: %s (found %d EPP specs)", placeableName, #foundEPPSpecs)

    -- Initialize defaults if not done yet (needed for meat yield calculations)
    EL_EPPButcherIntegration.initializeDefaults()

    -- Try to initialize (loads XML mappings, sets initialized flag)
    if not EL_EPPButcherIntegration.initialized then
        -- Add discovered spec names to our list
        for _, found in ipairs(foundEPPSpecs) do
            if not EL_EPPButcherIntegration.hasSpecName(found.name) then
                table.insert(EL_EPPButcherIntegration.eppSpecNames, found.name)
                Logging.info("[EL-EPP] Added EPP spec name to tracking: %s", found.name)
            end
        end

        -- Load XML mappings
        EL_EPPButcherIntegration.loadMappingsFromXML()

        -- Mark as initialized since we've confirmed EPP exists
        EL_EPPButcherIntegration.initialized = true
        Logging.info("[EL-EPP] Integration initialized via lazy detection")
    end

    -- Process all found EPP specs and hook their production points
    for _, found in ipairs(foundEPPSpecs) do
        local spec = found.spec

        -- Hook single productionPoint
        if spec.productionPoint ~= nil then
            Logging.info("[EL-EPP] Found productionPoint in spec %s", found.name)
            EL_EPPButcherIntegration.checkAndHookProductionPoint(spec.productionPoint)
        end

        -- Hook multiple productionPoints (if present)
        if spec.productionPoints ~= nil then
            for idx, pp in pairs(spec.productionPoints) do
                Logging.info("[EL-EPP] Found productionPoints[%s] in spec %s", tostring(idx), found.name)
                EL_EPPButcherIntegration.checkAndHookProductionPoint(pp)
            end
        end
    end
end


---
-- Check if a production point accepts animals and hook it if so.
-- @param productionPoint The production point to check
---
function EL_EPPButcherIntegration.checkAndHookProductionPoint(productionPoint)
    if productionPoint == nil then
        Logging.info("[EL-EPP] checkAndHookProductionPoint called with nil productionPoint")
        return
    end

    local ppName = productionPoint.name or (productionPoint.getName and productionPoint:getName()) or "unnamed"
    Logging.info("[EL-EPP] Checking production point: %s", ppName)

    -- Check if this production point accepts animals (has animal to fill type mapping)
    local acceptsAnimals = false
    local reason = "unknown"

    -- Method 1: Check for animalSubTypeToFillType mapping (EPP butchers have this)
    if productionPoint.animalSubTypeToFillType ~= nil and next(productionPoint.animalSubTypeToFillType) ~= nil then
        acceptsAnimals = true
        reason = "has animalSubTypeToFillType mapping"
    end

    -- Method 2: Check for animalTypeToFillType mapping
    if not acceptsAnimals and productionPoint.animalTypeToFillType ~= nil and next(productionPoint.animalTypeToFillType) ~= nil then
        acceptsAnimals = true
        reason = "has animalTypeToFillType mapping"
    end

    -- Method 3: Check inputFillTypes for animal fill types
    if not acceptsAnimals and productionPoint.inputFillTypes ~= nil then
        for fillType, _ in pairs(productionPoint.inputFillTypes) do
            local fillTypeDesc = g_fillTypeManager:getFillTypeByIndex(fillType)
            if fillTypeDesc ~= nil and fillTypeDesc.isAnimal then
                acceptsAnimals = true
                reason = string.format("inputFillTypes contains animal type: %s", fillTypeDesc.name or fillType)
                break
            end
        end
    end

    -- Method 4: Check for animal loading trigger (another indicator of animal-accepting PP)
    if not acceptsAnimals and productionPoint.animalLoadingTrigger ~= nil then
        acceptsAnimals = true
        reason = "has animalLoadingTrigger"
    end

    if acceptsAnimals then
        Logging.info("[EL-EPP] Production point '%s' accepts animals (%s) - hooking", ppName, reason)
        EL_EPPButcherIntegration.hookProductionPoint(productionPoint)
    else
        Logging.info("[EL-EPP] Production point '%s' does not accept animals - skipping", ppName)
    end
end


---
-- Hook into a specific production point's animal loading system.
-- @param productionPoint The production point to hook
---
function EL_EPPButcherIntegration.hookProductionPoint(productionPoint)
    if productionPoint._elHooked then
        Logging.info("[EL-EPP] Production point already hooked, skipping")
        return  -- Prevent double-hooking
    end

    local ppName = productionPoint.name or (productionPoint.getName and productionPoint:getName()) or "unnamed"
    local hooksApplied = {}

    -- Hook onAnimalTriggerCallback on the instance if it wasn't hooked on the class
    -- This handles cases where the class is not globally accessible
    if productionPoint.onAnimalTriggerCallback ~= nil and not productionPoint._elTriggerCallbackHooked then
        local originalCallback = productionPoint.onAnimalTriggerCallback
        productionPoint.onAnimalTriggerCallback = function(self, trigger, animal, isLeaving, ...)
            if not isLeaving and EL_EPPButcherIntegration.isELAnimal(animal) then
                Logging.info("[EL-EPP] Intercepted EL animal in onAnimalTriggerCallback")
                EL_EPPButcherIntegration.processELAnimal(self, animal, trigger and trigger.source or nil)
                return false
            end
            return originalCallback(self, trigger, animal, isLeaving, ...)
        end
        productionPoint._elTriggerCallbackHooked = true
        table.insert(hooksApplied, "onAnimalTriggerCallback")
    end

    -- Hook the animal loading trigger if it exists
    if productionPoint.animalLoadingTrigger ~= nil then
        local trigger = productionPoint.animalLoadingTrigger

        if trigger.addCluster ~= nil and not trigger.addClusterHookedByEL then
            local originalAddCluster = trigger.addCluster

            trigger.addCluster = function(triggerSelf, cluster, ...)
                -- Check if this is an EL animal
                if EL_EPPButcherIntegration.isELAnimal(cluster) then
                    return EL_EPPButcherIntegration.handleELAnimalAtTrigger(productionPoint, triggerSelf, cluster)
                end

                -- Not an EL animal, use default behavior
                return originalAddCluster(triggerSelf, cluster, ...)
            end
            trigger.addClusterHookedByEL = true
            table.insert(hooksApplied, "animalLoadingTrigger.addCluster")
        end
    end

    -- Hook the cluster system if it exists
    if productionPoint.clusterSystem ~= nil then
        local clusterSystem = productionPoint.clusterSystem

        if clusterSystem.addCluster ~= nil and not clusterSystem.addClusterHookedByEL then
            local originalAddCluster = clusterSystem.addCluster

            clusterSystem.addCluster = function(clusterSystemSelf, cluster, ...)
                -- Check if this is an EL animal
                if EL_EPPButcherIntegration.isELAnimal(cluster) then
                    return EL_EPPButcherIntegration.handleELAnimalAtClusterSystem(productionPoint, clusterSystemSelf, cluster)
                end

                -- Not an EL animal, use default behavior
                return originalAddCluster(clusterSystemSelf, cluster, ...)
            end
            clusterSystem.addClusterHookedByEL = true
            table.insert(hooksApplied, "clusterSystem.addCluster")
        end
    end

    -- Hook the production point's addCluster method directly if it exists
    if productionPoint.addCluster ~= nil and not productionPoint.addClusterHookedByEL then
        local originalAddCluster = productionPoint.addCluster

        productionPoint.addCluster = function(factorySelf, cluster, ...)
            -- Check if this is an EL animal
            if EL_EPPButcherIntegration.isELAnimal(cluster) then
                return EL_EPPButcherIntegration.processELAnimal(factorySelf, cluster, nil)
            end

            -- Not an EL animal, use default behavior
            return originalAddCluster(factorySelf, cluster, ...)
        end
        productionPoint.addClusterHookedByEL = true
        table.insert(hooksApplied, "addCluster")
    end

    productionPoint._elHooked = true

    -- Log summary of hooks applied
    if #hooksApplied > 0 then
        Logging.info("[EL-EPP] Successfully hooked production point '%s' with hooks: %s", ppName, table.concat(hooksApplied, ", "))
    else
        Logging.warning("[EL-EPP] Production point '%s' marked as hooked but no hooks were applied (methods may not exist)", ppName)
    end
end


---
-- Check if a cluster/animal is an Enhanced Livestock individual animal.
-- @param cluster The cluster to check
-- @return boolean True if this is an EL animal
---
function EL_EPPButcherIntegration.isELAnimal(cluster)
    if cluster == nil then
        return false
    end

    -- EL animals have these unique properties
    return cluster.weight ~= nil
       and cluster.genetics ~= nil
       and cluster.uniqueId ~= nil
       and cluster.isIndividual == true
end


---
-- Handle an EL animal being added to an animal loading trigger.
-- @param productionPoint The production point
-- @param trigger The animal loading trigger
-- @param animal The EL animal
-- @return boolean Success status
---
function EL_EPPButcherIntegration.handleELAnimalAtTrigger(productionPoint, trigger, animal)
    return EL_EPPButcherIntegration.processELAnimal(productionPoint, animal, trigger.source)
end


---
-- Handle an EL animal being added to a cluster system.
-- @param productionPoint The production point
-- @param clusterSystem The cluster system
-- @param animal The EL animal
-- @return boolean Success status
---
function EL_EPPButcherIntegration.handleELAnimalAtClusterSystem(productionPoint, clusterSystem, animal)
    return EL_EPPButcherIntegration.processELAnimal(productionPoint, animal, nil)
end


---
-- Process an EL animal at a butcher production point.
-- Sends event to server in multiplayer, or processes directly in singleplayer.
-- @param productionPoint The butcher production point
-- @param animal The EL animal to process
-- @param sourceObject Optional source husbandry/trailer
-- @return boolean Success status
---
function EL_EPPButcherIntegration.processELAnimal(productionPoint, animal, sourceObject)
    if animal == nil then
        return false
    end

    Logging.info("[EL-EPP] Processing EL animal at butcher: weight=%.1f, quality=%.2f",
        animal.weight or 0, animal.genetics and animal.genetics.quality or 1.0)

    if g_server ~= nil then
        -- Server or singleplayer - process directly
        local animalData = {
            weight = animal.weight or 100,
            quality = animal.genetics and animal.genetics.quality or 1.0,
            health = animal.health or 100,
            subTypeIndex = animal.subTypeIndex or 1
        }

        local clusterSystem = nil
        if sourceObject ~= nil and sourceObject.getClusterSystem ~= nil then
            clusterSystem = sourceObject:getClusterSystem()
        elseif animal.clusterSystem ~= nil then
            clusterSystem = animal.clusterSystem
        end

        local result = EL_EPPButcherIntegration.processAnimalOnServer(
            productionPoint,
            animal,
            animalData,
            clusterSystem
        )

        if result ~= nil and result.success then
            -- In singleplayer, show notification directly
            if g_dedicatedServer == nil then
                local fillTypeTitle = g_fillTypeManager:getFillTypeTitleByIndex(result.fillTypeIndex) or result.fillTypeName
                local animalTypeName = EL_EPPButcherIntegration.getAnimalTypeName(animal.animalTypeIndex)
                local message = string.format(
                    g_i18n:getText("el_epp_butcher_delivered") or "%s delivered to butcher (%.2fx %s)",
                    animalTypeName,
                    result.animalEquivalent,
                    fillTypeTitle
                )
                g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, message)
            else
                -- Dedicated server - broadcast to clients
                g_server:broadcastEvent(EPPButcherResultEvent.new(
                    {
                        uniqueId = animal.uniqueId,
                        farmId = animal.farmId,
                        country = animal.birthday and animal.birthday.country or 1,
                        animalTypeIndex = animal.animalTypeIndex
                    },
                    result.animalEquivalent,
                    result.fillTypeIndex,
                    result.fillTypeName
                ))
            end
        end

        return result ~= nil and result.success
    else
        -- Client - send event to server
        g_client:getServerConnection():sendEvent(
            EPPButcherProcessEvent.new(productionPoint, sourceObject, animal)
        )
        return true
    end
end


---
-- Server-side processing of an animal at a butcher.
-- Stores the animal as a fractional "animal equivalent" in the intermediate fill type.
-- The EPP production chain then converts this to final meat output.
-- @param productionPoint The butcher production point
-- @param animal The animal being processed
-- @param animalData Table with weight, quality, health, subTypeIndex
-- @param clusterSystem Optional cluster system to remove animal from
-- @return table|nil Result table with success, animalEquivalent, fillTypeIndex, fillTypeName
---
function EL_EPPButcherIntegration.processAnimalOnServer(productionPoint, animal, animalData, clusterSystem)
    if not g_server then
        return nil
    end

    -- Calculate animal equivalent (how many "standard" animals this EL animal is worth)
    local animalEquivalent = EL_EPPButcherIntegration.calculateAnimalEquivalent(animal, animalData)

    -- Resolve intermediate fill type (e.g., BEEF, PIGS - what the production chain uses as input)
    local fillTypeIndex, fillTypeName = EL_EPPButcherIntegration.getIntermediateFillType(productionPoint, animal)

    if fillTypeIndex == nil then
        Logging.warning("[EL-EPP] Could not resolve intermediate fill type for animal type %d", animal.animalTypeIndex or 0)
        return nil
    end

    Logging.info("[EL-EPP] Storing animal equivalent: %.3f of %s (fillTypeIndex=%d)",
        animalEquivalent, fillTypeName, fillTypeIndex)

    -- Add animal equivalent to production point storage
    -- The EPP production chain will then convert this to meat based on its production ratios
    local added = EL_EPPButcherIntegration.addToStorage(productionPoint, fillTypeIndex, animalEquivalent)

    if not added then
        Logging.warning("[EL-EPP] Failed to add animal equivalent to storage")
        return nil
    end

    -- Remove animal from source
    if clusterSystem ~= nil then
        local animalKey = animal.farmId .. " " .. animal.uniqueId .. " " .. (animal.birthday and animal.birthday.country or 1)
        clusterSystem:removeCluster(animalKey)
    elseif animal.animalTypeIndex ~= nil then
        -- Remove from global animal system
        local animals = g_currentMission.animalSystem.animals[animal.animalTypeIndex]
        if animals ~= nil then
            for i, a in pairs(animals) do
                if a.farmId == animal.farmId and
                   a.uniqueId == animal.uniqueId and
                   a.birthday and a.birthday.country == (animal.birthday and animal.birthday.country) then
                    table.remove(animals, i)
                    break
                end
            end
        end
    end

    return {
        success = true,
        animalEquivalent = animalEquivalent,
        fillTypeIndex = fillTypeIndex,
        fillTypeName = fillTypeName
    }
end


---
-- Calculate animal equivalent based on weight, quality, and health.
-- This calculates how many "standard" animals this EL animal is worth.
-- Formula: (weight / referenceWeight) * qualityFactor * healthFactor
-- A 600kg cow with quality 1.0 and 100% health vs 500kg reference = 1.2 animal equivalents
-- @param animal The animal
-- @param animalData Table with weight, quality, health
-- @return number Animal equivalents (fractional value, e.g., 1.2)
---
function EL_EPPButcherIntegration.calculateAnimalEquivalent(animal, animalData)
    local weight = animalData.weight or animal.weight or 100
    local quality = animalData.quality or (animal.genetics and animal.genetics.quality) or 1.0
    local health = animalData.health or animal.health or 100
    local animalType = animal.animalTypeIndex or (AnimalType ~= nil and AnimalType.COW) or 1

    -- Get reference weight for this animal type (what a "standard" animal weighs)
    local referenceWeight = 500  -- Default (standard cow)
    if EL_EPPButcherIntegration.REFERENCE_WEIGHT ~= nil and EL_EPPButcherIntegration.REFERENCE_WEIGHT[animalType] ~= nil then
        referenceWeight = EL_EPPButcherIntegration.REFERENCE_WEIGHT[animalType]
    end

    -- Calculate weight factor (how much heavier/lighter than reference)
    local weightFactor = weight / referenceWeight

    -- Quality factor: maps genetics quality (0.25-1.75) to modifier (0.7-1.3)
    -- quality=1.0 gives factor=1.0, quality=0.25 gives factor=0.7, quality=1.75 gives factor=1.3
    local qualityFactor = 0.6 + (quality * 0.4)

    -- Health factor: penalty below 50% health, minimum 0.5
    local healthFactor = math.max(0.5, health / 100)

    -- Calculate animal equivalent
    -- A heavy, high-quality, healthy animal is worth more than 1 standard animal
    local animalEquivalent = weightFactor * qualityFactor * healthFactor

    Logging.info("[EL-EPP] Animal equivalent calculation: weight=%.1f (ref=%.1f, factor=%.2f), quality=%.2f (factor=%.2f), health=%.0f (factor=%.2f) => %.3f equivalents",
        weight, referenceWeight, weightFactor, quality, qualityFactor, health, healthFactor, animalEquivalent)

    return animalEquivalent
end


---
-- Get the INTERMEDIATE fill type for an animal at a production point.
-- This returns the intermediate fill type (e.g., BEEF, PIGS) that the butcher's
-- production chain will convert to final meat. This allows EPP's production
-- system to work normally with EL's variable animal values.
-- @param productionPoint The production point
-- @param animal The animal
-- @return number|nil, string Fill type index and name, or nil if not found
---
function EL_EPPButcherIntegration.getIntermediateFillType(productionPoint, animal)
    local animalType = animal.animalTypeIndex or (AnimalType ~= nil and AnimalType.COW) or 1
    local subTypeIndex = animal.subTypeIndex or (animal.getSubTypeIndex ~= nil and animal:getSubTypeIndex()) or 1

    -- Method 1: Get from EPP's animalSubTypeToFillType mapping (e.g., subType -> BEEF)
    if productionPoint.animalSubTypeToFillType ~= nil then
        local fillType = productionPoint.animalSubTypeToFillType[subTypeIndex]
        if fillType ~= nil then
            local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillType)
            Logging.info("[EL-EPP] Using EPP animalSubTypeToFillType mapping: subType=%d -> %s",
                subTypeIndex, fillTypeName or "?")
            return fillType, fillTypeName or "UNKNOWN"
        end
    end

    -- Method 2: Get from EPP's animalTypeToFillType mapping (e.g., COW -> BEEF)
    if productionPoint.animalTypeToFillType ~= nil then
        local fillType = productionPoint.animalTypeToFillType[animalType]
        if fillType ~= nil then
            local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillType)
            Logging.info("[EL-EPP] Using EPP animalTypeToFillType mapping: type=%d -> %s",
                animalType, fillTypeName or "?")
            return fillType, fillTypeName or "UNKNOWN"
        end
    end

    -- Method 3: Fall back to EL's configured intermediate mapping
    local fillTypeName = nil
    if EL_EPPButcherIntegration.FILL_TYPE_MAPPING ~= nil then
        fillTypeName = EL_EPPButcherIntegration.FILL_TYPE_MAPPING[animalType]
    end

    if fillTypeName ~= nil then
        local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)
        if fillTypeIndex ~= nil then
            -- Verify this fill type is supported by the storage
            if productionPoint.storage ~= nil and productionPoint.storage.getIsFillTypeSupported ~= nil then
                if productionPoint.storage:getIsFillTypeSupported(fillTypeIndex) then
                    Logging.info("[EL-EPP] Using EL configured intermediate fill type: %s -> %s",
                        EL_EPPButcherIntegration.getAnimalTypeName(animalType), fillTypeName)
                    return fillTypeIndex, fillTypeName
                else
                    Logging.info("[EL-EPP] Configured fill type %s not supported by storage", fillTypeName)
                end
            else
                Logging.info("[EL-EPP] Using EL configured intermediate fill type: %s -> %s (no storage check)",
                    EL_EPPButcherIntegration.getAnimalTypeName(animalType), fillTypeName)
                return fillTypeIndex, fillTypeName
            end
        end
    end

    -- Method 4: Last resort - try common intermediate fill type names
    local fallbackNames = {"BEEF", "PIGS", "SHEEPGOAT", "POULTRY", "HORSEMEAT"}
    for _, name in ipairs(fallbackNames) do
        local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(name)
        if fillTypeIndex ~= nil then
            -- Verify this fill type is supported by the storage
            if productionPoint.storage ~= nil and productionPoint.storage.getIsFillTypeSupported ~= nil then
                if productionPoint.storage:getIsFillTypeSupported(fillTypeIndex) then
                    Logging.info("[EL-EPP] Using fallback intermediate fill type: %s", name)
                    return fillTypeIndex, name
                end
            else
                Logging.info("[EL-EPP] Using fallback intermediate fill type: %s (no storage check)", name)
                return fillTypeIndex, name
            end
        end
    end

    return nil, nil
end


---
-- Add fill amount to the production point's storage.
-- Tries multiple storage methods in order of preference.
-- @param productionPoint The production point
-- @param fillTypeIndex The fill type to add
-- @param amount The amount to add
-- @return boolean True if successfully added
---
function EL_EPPButcherIntegration.addToStorage(productionPoint, fillTypeIndex, amount)
    local fillTypeName = g_fillTypeManager:getFillTypeNameByIndex(fillTypeIndex) or tostring(fillTypeIndex)

    -- Log diagnostic info about available storage methods
    Logging.info("[EL-EPP] addToStorage: fillType=%s (idx=%d), amount=%.2f", fillTypeName, fillTypeIndex, amount)
    Logging.info("[EL-EPP] Storage diagnostics: storage=%s, unloadingStation=%s, fillLevels=%s",
        tostring(productionPoint.storage ~= nil),
        tostring(productionPoint.unloadingStation ~= nil),
        tostring(productionPoint.fillLevels ~= nil))

    -- Method 1: Direct storage access (recommended by third-party overrides script)
    -- This is the most reliable method for EPP production points
    if productionPoint.storage ~= nil then
        local storage = productionPoint.storage

        -- Check if fill type is supported
        local isSupported = true
        if storage.getIsFillTypeSupported ~= nil then
            isSupported = storage:getIsFillTypeSupported(fillTypeIndex)
            Logging.info("[EL-EPP] Storage supports fillType %s: %s", fillTypeName, tostring(isSupported))
        end

        if isSupported then
            -- Get current fill level
            local oldFillLevel = 0
            if storage.getFillLevel ~= nil then
                oldFillLevel = storage:getFillLevel(fillTypeIndex) or 0
            elseif storage.fillLevels ~= nil then
                oldFillLevel = storage.fillLevels[fillTypeIndex] or 0
            end

            -- Get capacity if available
            local capacity = math.huge
            if storage.getCapacity ~= nil then
                capacity = storage:getCapacity(fillTypeIndex) or math.huge
            end

            local freeCapacity = capacity - oldFillLevel
            local amountToAdd = math.min(amount, freeCapacity)

            Logging.info("[EL-EPP] Storage state: oldLevel=%.2f, capacity=%.2f, freeCapacity=%.2f, amountToAdd=%.2f",
                oldFillLevel, capacity, freeCapacity, amountToAdd)

            if amountToAdd > 0 then
                -- Try setFillLevel with 2 arguments first (as used by overrides script)
                if storage.setFillLevel ~= nil then
                    local success, err = pcall(function()
                        storage:setFillLevel(oldFillLevel + amountToAdd, fillTypeIndex)
                    end)

                    if not success then
                        -- Try with 3 arguments (fillInfo = nil)
                        success, err = pcall(function()
                            storage:setFillLevel(oldFillLevel + amountToAdd, fillTypeIndex, nil)
                        end)
                    end

                    if success then
                        local newFillLevel = 0
                        if storage.getFillLevel ~= nil then
                            newFillLevel = storage:getFillLevel(fillTypeIndex) or 0
                        elseif storage.fillLevels ~= nil then
                            newFillLevel = storage.fillLevels[fillTypeIndex] or 0
                        end
                        Logging.info("[EL-EPP] Successfully added %.2f to storage via setFillLevel (old=%.2f, new=%.2f)",
                            amountToAdd, oldFillLevel, newFillLevel)
                        return true
                    else
                        Logging.warning("[EL-EPP] setFillLevel failed: %s", tostring(err))
                    end
                end

                -- Try direct fillLevels table manipulation as fallback
                if storage.fillLevels ~= nil then
                    storage.fillLevels[fillTypeIndex] = (storage.fillLevels[fillTypeIndex] or 0) + amountToAdd
                    Logging.info("[EL-EPP] Added %.2f to storage.fillLevels table directly", amountToAdd)
                    return true
                end
            else
                Logging.warning("[EL-EPP] No free capacity in storage (capacity=%.2f, current=%.2f)", capacity, oldFillLevel)
            end
        end
    end

    -- Method 2: EPP's native storage method via unloadingStation.targetStorages
    -- This is how EPP's addCluster function works for external storages
    if productionPoint.unloadingStation ~= nil then
        local unloadingStation = productionPoint.unloadingStation
        local targetStorages = unloadingStation.targetStorages

        if targetStorages ~= nil then
            local storageCount = 0
            for _ in pairs(targetStorages) do storageCount = storageCount + 1 end
            Logging.info("[EL-EPP] Trying unloadingStation.targetStorages (%d storages)", storageCount)

            local addedAmount = 0

            for idx, targetStorage in pairs(targetStorages) do
                -- Check farm access if the method exists
                local hasAccess = true
                if unloadingStation.hasFarmAccessToStorage ~= nil and productionPoint.ownerFarmId ~= nil then
                    hasAccess = unloadingStation:hasFarmAccessToStorage(productionPoint.ownerFarmId, targetStorage)
                end

                Logging.info("[EL-EPP] targetStorage[%s]: hasAccess=%s", tostring(idx), tostring(hasAccess))

                if hasAccess then
                    -- Check fill type support
                    local isSupported = true
                    if targetStorage.getIsFillTypeSupported ~= nil then
                        isSupported = targetStorage:getIsFillTypeSupported(fillTypeIndex)
                    end

                    if isSupported then
                        local freeCapacity = 0
                        if targetStorage.getFreeCapacity ~= nil then
                            freeCapacity = targetStorage:getFreeCapacity(fillTypeIndex) or 0
                        elseif targetStorage.getCapacity ~= nil and targetStorage.getFillLevel ~= nil then
                            freeCapacity = (targetStorage:getCapacity(fillTypeIndex) or 0) - (targetStorage:getFillLevel(fillTypeIndex) or 0)
                        end

                        Logging.info("[EL-EPP] targetStorage[%s]: supports=%s, freeCapacity=%.2f",
                            tostring(idx), tostring(isSupported), freeCapacity)

                        if freeCapacity > 0 then
                            local amountToAdd = math.min(amount - addedAmount, freeCapacity)
                            local oldFillLevel = targetStorage:getFillLevel(fillTypeIndex) or 0

                            if targetStorage.setFillLevel ~= nil then
                                local success, err = pcall(function()
                                    targetStorage:setFillLevel(oldFillLevel + amountToAdd, fillTypeIndex)
                                end)
                                if not success then
                                    success, err = pcall(function()
                                        targetStorage:setFillLevel(oldFillLevel + amountToAdd, fillTypeIndex, nil)
                                    end)
                                end

                                if success then
                                    local newFillLevel = targetStorage:getFillLevel(fillTypeIndex) or 0
                                    addedAmount = addedAmount + (newFillLevel - oldFillLevel)
                                    Logging.info("[EL-EPP] Added %.2f to targetStorage[%s] (old=%.2f, new=%.2f)",
                                        amountToAdd, tostring(idx), oldFillLevel, newFillLevel)
                                end
                            end

                            if addedAmount >= amount - 0.001 then
                                break
                            end
                        end
                    end
                end
            end

            if addedAmount > 0 then
                Logging.info("[EL-EPP] Successfully added %.2f of %s via unloadingStation.targetStorages",
                    addedAmount, fillTypeName)
                return true
            end
        else
            Logging.info("[EL-EPP] unloadingStation exists but targetStorages is nil")
        end
    end

    -- Method 3: Direct fillLevels table on production point (last resort)
    if productionPoint.fillLevels ~= nil then
        productionPoint.fillLevels[fillTypeIndex] = (productionPoint.fillLevels[fillTypeIndex] or 0) + amount
        Logging.info("[EL-EPP] Added %.2f to productionPoint.fillLevels table directly", amount)
        return true
    end

    -- Method 4: Try using ProductionPoint superclass method if available
    if productionPoint.setFillLevel ~= nil then
        local success, err = pcall(function()
            productionPoint:setFillLevel(fillTypeIndex, amount)
        end)
        if success then
            Logging.info("[EL-EPP] Added %.2f via productionPoint:setFillLevel", amount)
            return true
        else
            Logging.warning("[EL-EPP] productionPoint:setFillLevel failed: %s", tostring(err))
        end
    end

    Logging.warning("[EL-EPP] Could not find valid storage method for production point")
    Logging.warning("[EL-EPP] Available properties: storage=%s, unloadingStation=%s, fillLevels=%s, setFillLevel=%s",
        tostring(productionPoint.storage ~= nil),
        tostring(productionPoint.unloadingStation ~= nil),
        tostring(productionPoint.fillLevels ~= nil),
        tostring(productionPoint.setFillLevel ~= nil))
    return false
end


---
-- Get a human-readable name for an animal type.
-- @param animalTypeIndex The animal type index
-- @return string The animal type name
---
function EL_EPPButcherIntegration.getAnimalTypeName(animalTypeIndex)
    if AnimalType == nil then
        return "Animal"
    end

    local typeNames = {}
    if AnimalType.COW ~= nil then typeNames[AnimalType.COW] = "Cattle" end
    if AnimalType.PIG ~= nil then typeNames[AnimalType.PIG] = "Pig" end
    if AnimalType.SHEEP ~= nil then typeNames[AnimalType.SHEEP] = "Sheep" end
    if AnimalType.CHICKEN ~= nil then typeNames[AnimalType.CHICKEN] = "Chicken" end
    if AnimalType.HORSE ~= nil then typeNames[AnimalType.HORSE] = "Horse" end

    return typeNames[animalTypeIndex] or "Animal"
end
