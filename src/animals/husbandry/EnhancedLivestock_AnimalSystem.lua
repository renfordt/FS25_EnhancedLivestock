EnhancedLivestock_AnimalSystem = {}

local modName = g_currentModName
local modDirectory = g_currentModDirectory

-- Bull Status Tier System
BullTier = {
	YOUNG_GENOMIC = 1,
	PROVEN = 2,
	ELITE = 3,
	LEGEND = 4
}

-- Stock limits by tier
BullTierStockLimits = {
	[BullTier.YOUNG_GENOMIC] = {
		initialStock = 500,
		maxPerPurchase = 200,
		restockRate = "daily",
		restockAmount = 100
	},
	[BullTier.PROVEN] = {
		initialStock = 200,
		maxPerPurchase = 100,
		restockRate = "daily",
		restockAmount = 50
	},
	[BullTier.ELITE] = {
		initialStock = 50,
		maxPerPurchase = 20,
		restockRate = "weekly",
		restockAmount = 10
	},
	[BullTier.LEGEND] = {
		initialStock = 5,
		maxPerPurchase = 5,
		restockRate = "never",
		restockAmount = 0
	}
}

-- Tier-based price multipliers
BullTierPriceMultipliers = {
	[BullTier.YOUNG_GENOMIC] = 1.0,
	[BullTier.PROVEN] = 1.5,
	[BullTier.ELITE] = 4.0,
	[BullTier.LEGEND] = 20.0
}

local function getDaysInMonth(month)
	local daysPerMonth = EnhancedLivestock ~= nil and EnhancedLivestock.DAYS_PER_MONTH or nil
	if daysPerMonth == nil then
		Logging.warning("[EnhancedLivestock] DAYS_PER_MONTH not available, using fallback of 1")
		return 1
	end
	local days = daysPerMonth[month]
	if days == nil then
		Logging.warning("[EnhancedLivestock] No days defined for month %d, using fallback of 1", month)
		return 1
	end
	return days
end

table.insert(FinanceStats.statNames, "monitorSubscriptions")
FinanceStats.statNameToIndex["monitorSubscriptions"] = #FinanceStats.statNames

AnimalSystem.BREED_TO_NAME = {
	["HOLSTEIN"] = "Holstein",
	["SWISS_BROWN"] = "Swiss Brown",
	["ANGUS"] = "Angus",
	["LIMOUSIN"] = "Limousin",
	["HEREFORD"] = "Hereford",
	["HIGHLAND"] = "Highland",
	["WATER_BUFFALO"] = "Water Buffalo",
	["LANDRACE"] = "Landrace",
	["BLACK_PIED"] = "Black Pied",
	["BERKSHIRE"] = "Berkshire",
	["STEINSCHAF"] = "Steinschaf",
	["SWISS_MOUNTAIN"] = "Swiss Mountain",
	["BLACK_WELSH"] = "Black Welsh",
	["GOAT"] = "Goat",
	["GRAY"] = "Gray",
	["PINTO"] = "Pinto",
	["PALOMINO"] = "Palomino",
	["CHESTNUT"] = "Chestnut",
	["BAY"] = "Bay",
	["BLACK"] = "Black",
	["SEAL_BROWN"] = "Seal Brown",
	["DUN"] = "Dun",
	["CHICKEN"] = "Chicken",
	["DUCK"] = "Duck",
	["DUCKWILD"] = "Duck",
	["RABBIT"] = "Rabbit",
	["GOOSE"] = "Goose",
	["CAT"] = "Cat",
	["OTHER"] = "Unknown"
}

AnimalSystem.BREED_TO_MARKER_COLOUR = {
	["HOLSTEIN"] = { 1, 0, 0 },
	["SWISS_BROWN"] = { 1, 1, 0 },
	["ANGUS"] = { 1, 1, 1 },
	["LIMOUSIN"] = { 0, 0, 1 },
	["HEREFORD"] = { 0, 0, 1 },
	["WATER_BUFFALO"] = { 1, 1, 1 }
}

function EnhancedLivestock_AnimalSystem:loadMapData(_, mapXml, mission, baseDirectory)

	ELSettings.initialize()
	ELSettings.validateCustomAnimalsConfiguration()

	self.customEnvironment = modName

	self.baseColours = {
		["earTagLeft"] = { 0.8, 0.7, 0 },
		["earTagRight"] = { 0.8, 0.7, 0 },
		["earTagLeft_text"] = { 0, 0, 0 },
		["earTagRight_text"] = { 0, 0, 0 }
	}

	-- NEW BRIDGE SYSTEM: Phased Loading
	-- Phase 1: Load base EL animals (unless a bridge uses mode="replace")
	local hasBridges = g_bridgeRegistry and #g_bridgeRegistry:getBridges() > 0
	local skipBaseAnimals = false

	if hasBridges then
		-- Check if any bridge uses replace mode
		for _, bridge in ipairs(g_bridgeRegistry:getBridges()) do
			if bridge.loadingMode == "replace" then
				skipBaseAnimals = true
				Logging.info("[EL Bridge] Bridge '%s' using replace mode - skipping base animals", bridge.modName)
				break
			end
		end
	end

	if not skipBaseAnimals then
		-- Load base EL animals.xml
		local path = ELSettings.getAnimalsXMLPath() or (modDirectory .. "xml/animals.xml")
		Logging.info("[Enhanced Livestock] Loading base animals from '%s'", path)

		local xmlFile = XMLFile.load("animals", path)
		if xmlFile ~= nil then
			self:loadAnimals(xmlFile, modDirectory)
			xmlFile:delete()
		end
	end

	-- Phase 2: Load bridge animals (merge/extend/override)
	if hasBridges then
		for _, bridge in ipairs(g_bridgeRegistry:getBridges()) do
			if bridge.resources.animals then
				local animalsPath = bridge.bridgeDirectory .. bridge.resources.animals
				if fileExists(animalsPath) then
					Logging.info("[EL Bridge] Loading animals from bridge: %s", bridge.modName)
					self:loadBridgeAnimals(bridge, animalsPath)
				else
					Logging.warning("[EL Bridge] Animals file not found: %s", animalsPath)
				end
			end

			-- Merge bridge nutrition data if provided
			if bridge.resources.nutrition and g_nutritionManager then
				local nutritionPath = bridge.bridgeDirectory .. bridge.resources.nutrition
				if fileExists(nutritionPath) then
					Logging.info("[EL Bridge] Merging nutrition data from bridge: %s", bridge.modName)
					g_nutritionManager:mergeFromXML(nutritionPath)
				end
			end
		end
	end

	-- Phase 3: Load vanilla animals from map (if not overridden by bridges)
	self.customEnvironment = mission.customEnvironment

	local baseFilename = getXMLString(mapXml, "map.animals#filename")
	local shouldLoadVanillaAnimals = true

	-- Check if any bridge overrides vanilla animals
	if hasBridges then
		for _, bridge in ipairs(g_bridgeRegistry:getBridges()) do
			if bridge.loadingMode == "merge" or bridge.loadingMode == "replace" then
				shouldLoadVanillaAnimals = false
				Logging.info("[EL Bridge] Bridge '%s' overriding vanilla animals", bridge.modName)
				break
			end
		end
	end

	if baseFilename == nil or baseFilename == "" then
		Logging.info("[Enhanced Livestock] No animals xml given at 'map.animals#filename'")
	elseif #self.types == 0 or shouldLoadVanillaAnimals then
		local baseXmlFile = XMLFile.load("animals", Utils.getFilename(baseFilename, baseDirectory))
		if baseXmlFile ~= nil then
			self:loadAnimals(baseXmlFile, baseDirectory)
			baseXmlFile:delete()
		end
	end

	self.customEnvironment = modName

	-- Phase 4: Validate animals and generate defaults
	if g_bridgeRegistry then
		g_bridgeRegistry:validateAnimals(self)
	end

	Logging.info("[Enhanced Livestock] Loaded %s animals:", #self.types)

	for _, type in pairs(self.types) do

		Logging.info("- Animal Type: %s (%s subTypes)", type.name, #type.subTypes)

		for i, subTypeIndex in pairs(type.subTypes) do

			Logging.info("|--- SubType (%s): %s (%s)", i, self.subTypes[subTypeIndex].name, self.subTypes[subTypeIndex].gender)

		end

	end

	self:loadColourConfigurations()

	return #self.types > 0

end

---Load config overrides from bridge XML
---Updates animalType.configFilename for types where the map's 3D model config
---has additional models beyond the base game config. Without this, the C++ engine
---only loads base game models and map-specific visual indices cause "invalid animal subtype" errors.
---@param xmlFile table XMLFile handle
---@param bridge table The bridge object
function EnhancedLivestock_AnimalSystem:loadConfigOverrides(xmlFile, bridge)
	local overrideCount = 0

	-- Resolve the map mod's directory for config path resolution
	local mapModDir = g_modNameToDirectory and g_modNameToDirectory[bridge.modName]
	if not mapModDir then
		Logging.warning("[EL Bridge] Could not resolve mod directory for '%s', using bridge directory", bridge.modName)
		mapModDir = bridge.bridgeDirectory
	end

	xmlFile:iterate("bridgeAnimals.configOverrides.override", function(index, key)
		local rawTypeName = xmlFile:getString(key .. "#type")
		local rawConfigFilename = xmlFile:getString(key .. "#configFilename")

		if not rawTypeName or not rawConfigFilename then
			Logging.warning("[EL Bridge] Config override missing 'type' or 'configFilename' attribute, skipping")
			return
		end

		local typeName = rawTypeName:upper()
		local animalType = self.nameToType[typeName]

		if not animalType then
			Logging.warning("[EL Bridge] Config override type '%s' not found in AnimalSystem, skipping", typeName)
			return
		end

		local resolvedPath = Utils.getFilename(rawConfigFilename, mapModDir)
		local oldPath = animalType.configFilename

		animalType.configFilename = resolvedPath
		overrideCount = overrideCount + 1

		Logging.info("[EL Bridge] Config override for '%s': '%s' -> '%s'", typeName, oldPath, resolvedPath)
	end)

	if overrideCount > 0 then
		Logging.info("[EL Bridge] Applied %d config override(s) for '%s'", overrideCount, bridge.name)
	end
end

---Load animals from a bridge
---Supports import, extend, animal, and override operations
---@param bridge table The bridge object
---@param animalsPath string Path to the bridge's animals.xml
function EnhancedLivestock_AnimalSystem:loadBridgeAnimals(bridge, animalsPath)
	local xmlFile = XMLFile.load("bridge_animals_" .. bridge.modName, animalsPath)
	if not xmlFile then
		Logging.warning("[EL Bridge] Failed to load animals XML: %s", animalsPath)
		return
	end

	-- Resolve the map mod's directory for image path resolution
	local mapModDir = g_modNameToDirectory and g_modNameToDirectory[bridge.modName]
	if not mapModDir then
		Logging.warning("[EL Bridge] Could not resolve mod directory for '%s', using bridge directory", bridge.modName)
		mapModDir = bridge.bridgeDirectory
	end

	-- Process <import> tags - load base EL animals if specified
	xmlFile:iterate("bridgeAnimals.import", function(index, key)
		local sourcePath = xmlFile:getString(key .. "#source")
		if sourcePath then
			local originalPath = sourcePath
			sourcePath = g_bridgeUtils.resolveModdirPath(sourcePath)

			if fileExists(sourcePath) then
				Logging.info("[EL Bridge] Importing animals from: %s", sourcePath)

				-- Determine the base directory for the imported file
				-- If it's from $moddir$ModName/, use that mod's directory
				-- Otherwise use EL's modDirectory
				local baseDir = modDirectory
				local modMatch = originalPath:match("^%$moddir%$([^/]+)/")
				if modMatch then
					local modDir = g_modNameToDirectory and g_modNameToDirectory[modMatch]
					if modDir then
						baseDir = modDir
					end
				end

				local importXmlFile = XMLFile.load("import_animals_" .. index, sourcePath)
				if importXmlFile then
					self:loadAnimals(importXmlFile, baseDir)
					importXmlFile:delete()
				end
			else
				Logging.warning("[EL Bridge] Import source not found: %s", sourcePath)
			end
		end
	end)

	-- Process <extend> tags - add new subtypes to existing types
	xmlFile:iterate("bridgeAnimals.extend", function(index, key)
		local typeName = xmlFile:getString(key .. "#type")
		if not typeName then
			Logging.warning("[EL Bridge] Missing type in extend tag")
			return
		end

		typeName = typeName:upper()

		-- Find existing type
		local existingType = nil
		for _, animalType in ipairs(self.types) do
			if animalType.name == typeName then
				existingType = animalType
				break
			end
		end

		if not existingType then
			Logging.warning("[EL Bridge] Cannot extend type '%s' - type not found", typeName)
			return
		end

		-- Load subtypes from this extend block
		xmlFile:iterate(key .. ".subType", function(subIndex, subKey)
			-- Load subtype as if it were part of the original type
			-- This reuses the existing loadAnimals subtype loading logic
			local subTypeXml = XMLFile.create("temp_subtype", nil, "animal")
			if subTypeXml then
				-- Copy type attributes
				subTypeXml:setValue("animal#type", typeName)

				-- Copy all subtype data
				local subTypeName = xmlFile:getString(subKey .. "#subType")
				if subTypeName then
					-- Create a temporary XML structure to load this subtype
					-- Note: This is a simplified approach - in production, we'd need to
					-- copy all attributes and child elements from the bridge XML
					Logging.info("[EL Bridge] Extending type '%s' with subtype '%s'", typeName, subTypeName)

					-- For now, just log that we'd extend here
					-- Full implementation would require copying all XML data
					Logging.warning("[EL Bridge] Extend implementation incomplete - manual migration required")
				end
				subTypeXml:delete()
			end
		end)
	end)

	-- Process <configOverrides> tags FIRST - update configFilename before loading subtypes
	-- This ensures the C++ engine loads the correct visual model config
	self:loadConfigOverrides(xmlFile, bridge)

	-- Process <animal> tags - new species or extensions to existing species
	-- Use mapModDir so image paths resolve relative to the map mod, not the bridge directory
	self:loadAnimals(xmlFile, mapModDir, "bridgeAnimals.animal")

	-- Process <override> tags - modify existing definitions
	xmlFile:iterate("bridgeAnimals.override", function(index, key)
		local typeName = xmlFile:getString(key .. "#type")
		local subTypeName = xmlFile:getString(key .. "#subType")

		if not typeName then
			Logging.warning("[EL Bridge] Missing type in override tag")
			return
		end

		typeName = typeName:upper()

		-- Find the animal type
		local animalType = nil
		for _, type in ipairs(self.types) do
			if type.name == typeName then
				animalType = type
				break
			end
		end

		if not animalType then
			Logging.warning("[EL Bridge] Cannot override type '%s' - not found", typeName)
			return
		end

		if subTypeName then
			-- Override specific subtype
			subTypeName = subTypeName:upper()
			local subType = nil

			for _, subTypeIndex in ipairs(animalType.subTypes) do
				if self.subTypes[subTypeIndex].subTypeName == subTypeName then
					subType = self.subTypes[subTypeIndex]
					break
				end
			end

			if not subType then
				Logging.warning("[EL Bridge] Cannot override subtype '%s/%s' - not found", typeName, subTypeName)
				return
			end

			-- Apply overrides to subtype
			self:applySubTypeOverrides(subType, xmlFile, key)
			Logging.info("[EL Bridge] Applied overrides to %s/%s", typeName, subTypeName)
		else
			-- Override type-level properties
			self:applyTypeOverrides(animalType, xmlFile, key)
			Logging.info("[EL Bridge] Applied overrides to type %s", typeName)
		end
	end)

	-- Process <propertyOverrides> tags - batch property overrides for imported subTypes
	-- Runs AFTER imports and overrides so all subTypes are registered
	xmlFile:iterate("bridgeAnimals.propertyOverrides.animal", function(index, key)
		local typeName = xmlFile:getString(key .. "#type")
		if not typeName then
			Logging.warning("[EL Bridge] Missing type in propertyOverrides animal tag")
			return
		end

		typeName = typeName:upper()
		local animalType = self.nameToType[typeName]

		if not animalType then
			Logging.warning("[EL Bridge] Cannot apply property overrides for type '%s' - not found", typeName)
			return
		end

		-- Apply type-level overrides if any attributes are present on the <animal> element
		self:applyTypeOverrides(animalType, xmlFile, key)

		-- Apply subType-level overrides
		xmlFile:iterate(key .. ".subType", function(subIndex, subKey)
			local subTypeName = xmlFile:getString(subKey .. "#subType")
			if not subTypeName then
				Logging.warning("[EL Bridge] Missing subType in propertyOverrides")
				return
			end

			subTypeName = subTypeName:upper()
			local subType = self.nameToSubType[subTypeName]

			if not subType then
				-- Not an error: subType may have been skipped during import (duplicate name)
				return
			end

			self:applySubTypeOverrides(subType, xmlFile, subKey)
		end)
	end)

	xmlFile:delete()
end

---Apply overrides to a subtype
---Supports direct attributes (#gender, #minWeight, #targetWeight, #maxWeight, #breed),
---reproduction, health, visuals, prices (buyPrice, sellPrice, transportPrice),
---input curves (food, straw, water), and output curves (manure, liquidManure, milk, pallets).
---@param subType table The subtype to override
---@param xmlFile table The XML file with override data
---@param key string The XML key path
function EnhancedLivestock_AnimalSystem:applySubTypeOverrides(subType, xmlFile, key)
	local patches = {}

	-- Direct attributes (RM-style flat attributes on the subType element)
	local gender = xmlFile:getString(key .. "#gender")
	if gender then
		subType.gender = gender
		table.insert(patches, "gender=" .. gender)
	end

	local minWeight = xmlFile:getFloat(key .. "#minWeight")
	if minWeight then
		subType.minWeight = minWeight
		table.insert(patches, "minWeight=" .. minWeight)
	end

	local targetWeight = xmlFile:getFloat(key .. "#targetWeight")
	if targetWeight then
		subType.targetWeight = targetWeight
		table.insert(patches, "targetWeight=" .. targetWeight)
	end

	local maxWeight = xmlFile:getFloat(key .. "#maxWeight")
	if maxWeight then
		subType.maxWeight = maxWeight
		table.insert(patches, "maxWeight=" .. maxWeight)
	end

	-- Breed override with breed-group reassignment
	local breed = xmlFile:getString(key .. "#breed")
	if breed then
		local animalType = nil
		for _, t in ipairs(self.types) do
			if t.typeIndex == subType.typeIndex then
				animalType = t
				break
			end
		end

		-- Remove from old breed group
		if animalType and subType.breed then
			local oldBreedGroup = animalType.breeds[subType.breed]
			if oldBreedGroup then
				for i, st in ipairs(oldBreedGroup) do
					if st == subType then
						table.remove(oldBreedGroup, i)
						break
					end
				end
				if #oldBreedGroup == 0 then
					animalType.breeds[subType.breed] = nil
				end
			end
		end

		subType.breed = breed

		-- Add to new breed group
		if animalType then
			if animalType.breeds[breed] == nil then
				animalType.breeds[breed] = {}
			end
			table.insert(animalType.breeds[breed], subType)
		end

		table.insert(patches, "breed=" .. breed)
	end

	-- Reproduction overrides
	local reproSupported = xmlFile:getBool(key .. ".reproduction#supported")
	if reproSupported ~= nil then
		subType.supportsReproduction = reproSupported
		table.insert(patches, "reproduction.supported=" .. tostring(reproSupported))
	end

	local reproMinAge = xmlFile:getInt(key .. ".reproduction#minAgeMonth")
	if reproMinAge then
		subType.reproductionMinAgeMonth = reproMinAge
		table.insert(patches, "reproduction.minAgeMonth=" .. reproMinAge)
	end

	local reproDuration = xmlFile:getInt(key .. ".reproduction#durationMonth")
	if reproDuration then
		subType.reproductionDurationMonth = reproDuration
		table.insert(patches, "reproduction.durationMonth=" .. reproDuration)
	end

	local reproMinHealth = xmlFile:getFloat(key .. ".reproduction#minHealthFactor")
	if reproMinHealth then
		subType.reproductionMinHealth = reproMinHealth
		table.insert(patches, "reproduction.minHealthFactor=" .. reproMinHealth)
	end

	-- Health overrides
	local healthIncrease = xmlFile:getFloat(key .. ".health#increasePerHour")
	if healthIncrease then
		subType.healthIncreaseHour = healthIncrease
		table.insert(patches, "health.increasePerHour=" .. healthIncrease)
	end

	local healthDecrease = xmlFile:getFloat(key .. ".health#decreasePerHour")
	if healthDecrease then
		subType.healthDecreaseHour = healthDecrease
		table.insert(patches, "health.decreasePerHour=" .. healthDecrease)
	end

	-- Visuals template override
	local visualsTemplate = xmlFile:getString(key .. ".visuals#template")
	if visualsTemplate then
		subType.visualsTemplate = visualsTemplate
		table.insert(patches, "visuals.template=" .. visualsTemplate)
	end

	-- Legacy support: also check nested <weights> elements for backward compatibility
	if not minWeight then
		local legacyMin = xmlFile:getFloat(key .. ".weights#minWeight")
		if legacyMin then
			subType.minWeight = legacyMin
			table.insert(patches, "minWeight=" .. legacyMin .. " (legacy)")
		end
	end
	if not targetWeight then
		local legacyTarget = xmlFile:getFloat(key .. ".weights#targetWeight")
		if legacyTarget then
			subType.targetWeight = legacyTarget
			table.insert(patches, "targetWeight=" .. legacyTarget .. " (legacy)")
		end
	end
	if not maxWeight then
		local legacyMax = xmlFile:getFloat(key .. ".weights#maxWeight")
		if legacyMax then
			subType.maxWeight = legacyMax
			table.insert(patches, "maxWeight=" .. legacyMax .. " (legacy)")
		end
	end

	-- Price overrides (AnimCurves)
	local buyPrice = self:loadAnimCurve(xmlFile, key .. ".buyPrice")
	if buyPrice then
		subType.buyPrice = buyPrice
		table.insert(patches, "buyPrice")
	end

	local sellPrice = self:loadAnimCurve(xmlFile, key .. ".sellPrice")
	if sellPrice then
		subType.sellPrice = sellPrice
		table.insert(patches, "sellPrice")
	end

	local transportPrice = self:loadAnimCurve(xmlFile, key .. ".transportPrice")
	if transportPrice then
		subType.transportPrice = transportPrice
		table.insert(patches, "transportPrice")
	end

	-- Input overrides (AnimCurves)
	local foodCurve = self:loadAnimCurve(xmlFile, key .. ".input.food")
	if foodCurve then
		if subType.input == nil then
			subType.input = {}
		end
		subType.input.food = foodCurve
		table.insert(patches, "input.food")
	end

	local strawCurve = self:loadAnimCurve(xmlFile, key .. ".input.straw")
	if strawCurve then
		if subType.input == nil then
			subType.input = {}
		end
		subType.input.straw = strawCurve
		table.insert(patches, "input.straw")
	end

	local waterCurve = self:loadAnimCurve(xmlFile, key .. ".input.water")
	if waterCurve then
		if subType.input == nil then
			subType.input = {}
		end
		subType.input.water = waterCurve
		table.insert(patches, "input.water")
	end

	-- Output overrides (AnimCurves)
	local manureCurve = self:loadAnimCurve(xmlFile, key .. ".output.manure")
	if manureCurve then
		if subType.output == nil then
			subType.output = {}
		end
		subType.output.manure = manureCurve
		table.insert(patches, "output.manure")
	end

	local liquidManureCurve = self:loadAnimCurve(xmlFile, key .. ".output.liquidManure")
	if liquidManureCurve then
		if subType.output == nil then
			subType.output = {}
		end
		subType.output.liquidManure = liquidManureCurve
		table.insert(patches, "output.liquidManure")
	end

	-- Milk output (AnimCurve + optional fillType override)
	if xmlFile:hasProperty(key .. ".output.milk") then
		local milkCurve = self:loadAnimCurve(xmlFile, key .. ".output.milk")
		if milkCurve then
			if subType.output == nil then
				subType.output = {}
			end
			local milkFillTypeName = xmlFile:getString(key .. ".output.milk#fillType")
			local existingFillType = subType.output.milk and subType.output.milk.fillType or nil
			subType.output.milk = {
				fillType = milkFillTypeName and g_fillTypeManager:getFillTypeIndexByName(milkFillTypeName) or existingFillType,
				curve = milkCurve
			}
			table.insert(patches, "output.milk")
		end
	end

	-- Pallets output (AnimCurve + optional fillType override)
	if xmlFile:hasProperty(key .. ".output.pallets") then
		local palletsCurve = self:loadAnimCurve(xmlFile, key .. ".output.pallets")
		if palletsCurve then
			if subType.output == nil then
				subType.output = {}
			end
			local palletsFillTypeName = xmlFile:getString(key .. ".output.pallets#fillType")
			local existingFillType = subType.output.pallets and subType.output.pallets.fillType or nil
			subType.output.pallets = {
				fillType = palletsFillTypeName and g_fillTypeManager:getFillTypeIndexByName(palletsFillTypeName) or existingFillType,
				curve = palletsCurve
			}
			table.insert(patches, "output.pallets")
		end
	end

	if #patches > 0 then
		Logging.info("[EL Bridge] SubType '%s' overrides: %s", subType.name, table.concat(patches, ", "))
	end
end

---Apply overrides to a type
---Supports groupTitle, averageBuyAge, maxBuyAge, pasture sqmPerAnimal, pregnancy, and fertility.
---@param animalType table The animal type to override
---@param xmlFile table The XML file with override data
---@param key string The XML key path
function EnhancedLivestock_AnimalSystem:applyTypeOverrides(animalType, xmlFile, key)
	local patches = {}

	local groupTitle = xmlFile:getString(key .. "#groupTitle")
	if groupTitle then
		animalType.groupTitle = groupTitle
		table.insert(patches, "groupTitle")
	end

	local averageBuyAge = xmlFile:getInt(key .. "#averageBuyAge")
	if averageBuyAge then
		animalType.averageBuyAge = averageBuyAge
		table.insert(patches, "averageBuyAge=" .. averageBuyAge)
	end

	local maxBuyAge = xmlFile:getInt(key .. "#maxBuyAge")
	if maxBuyAge then
		animalType.maxBuyAge = maxBuyAge
		table.insert(patches, "maxBuyAge=" .. maxBuyAge)
	end

	local sqmPerAnimal = xmlFile:getFloat(key .. ".pasture#sqmPerAnimal")
	if sqmPerAnimal then
		animalType.sqmPerAnimal = sqmPerAnimal
		table.insert(patches, "sqmPerAnimal=" .. sqmPerAnimal)
	end

	-- Pregnancy override: rebuild pregnancy function if average or max changed
	local pregnancyAverage = xmlFile:getInt(key .. ".pregnancy#average")
	local pregnancyMax = xmlFile:getInt(key .. ".pregnancy#max")
	if pregnancyAverage or pregnancyMax then
		local avg = pregnancyAverage or animalType.pregnancy.average
		local maxC = pregnancyMax or (avg + 2)

		local pregnancy = {}
		local totalChance = 0

		for i = 0, avg - 1 do
			totalChance = totalChance + (i / avg) / maxC
			table.insert(pregnancy, totalChance)
		end

		totalChance = totalChance + 0.5
		table.insert(pregnancy, totalChance)

		for i = avg + 1, maxC - 1 do
			totalChance = totalChance + (1 - totalChance) * 0.8
			table.insert(pregnancy, totalChance)
		end

		table.insert(pregnancy, 1)

		local function pregnancyFunction(value)
			for i = 0, #pregnancy - 1 do
				if pregnancy[i + 1] > value then
					return i
				end
			end
			return 0
		end

		animalType.pregnancy = {
			["get"] = pregnancyFunction,
			["average"] = avg
		}
		table.insert(patches, "pregnancy(avg=" .. avg .. ",max=" .. maxC .. ")")
	end

	-- Fertility curve override
	local fertility = self:loadAnimCurve(xmlFile, key .. ".fertility")
	if fertility then
		animalType.fertility = fertility
		table.insert(patches, "fertility")
	end

	if #patches > 0 then
		Logging.info("[EL Bridge] Type '%s' overrides: %s", animalType.name, table.concat(patches, ", "))
	end
end

-- Register bridge loading methods on AnimalSystem
AnimalSystem.loadConfigOverrides = EnhancedLivestock_AnimalSystem.loadConfigOverrides
AnimalSystem.loadBridgeAnimals = EnhancedLivestock_AnimalSystem.loadBridgeAnimals
AnimalSystem.applySubTypeOverrides = EnhancedLivestock_AnimalSystem.applySubTypeOverrides
AnimalSystem.applyTypeOverrides = EnhancedLivestock_AnimalSystem.applyTypeOverrides

AnimalSystem.loadMapData = Utils.overwrittenFunction(AnimalSystem.loadMapData, EnhancedLivestock_AnimalSystem.loadMapData)

function EnhancedLivestock_AnimalSystem:loadAnimals(_, xmlFile, directory, rootPath)

	rootPath = rootPath or "animals.animal"

	for _, key in xmlFile:iterator(rootPath) do

		if #self.types >= 2 ^ AnimalSystem.SEND_NUM_BITS - 1 then
			Logging.xmlWarning(xmlFile, "[EnhancedLivestock] Maximum number of supported animal types reached. Ignoring remaining types")
			return
		end

		local rawName = xmlFile:getString(key .. "#type")

		if rawName == nil then
			Logging.xmlError(xmlFile, "[EnhancedLivestock] Missing animal type. \'%s\'", key)
			return
		end

		local name = rawName:upper()
		local rawConfigFilename = xmlFile:getString(key .. ".configFilename")

		-- Check if type already exists (for bridge extensions that add subtypes to existing types)
		local typeAlreadyExists = self.nameToTypeIndex[name] ~= nil

		if rawConfigFilename == nil and not typeAlreadyExists then
			Logging.xmlError(xmlFile, "[EnhancedLivestock] Missing config file for animal type \'%s\'. \'%s\'", name, key)
			return
		end

		-- Resolve cross-mod $moddir$ModName/ references to actual mod directories
		local resolvedBaseDir = directory
		local resolvedConfigFilename = rawConfigFilename
		local configFilename = nil

		if rawConfigFilename ~= nil then
			local modRef = rawConfigFilename:match("^%$moddir%$([^/]+)/")
			if modRef ~= nil then
				local modDir = g_modNameToDirectory[modRef]
				if modDir ~= nil then
					resolvedConfigFilename = rawConfigFilename:gsub("^%$moddir%$[^/]+/", "")
					resolvedBaseDir = modDir
				end
			end

			configFilename = Utils.getFilename(resolvedConfigFilename, resolvedBaseDir)
		end

		local animalType

		if typeAlreadyExists then

			animalType = self.nameToType[name]

		else

			local clusterClass = xmlFile:getString(key .. "#clusterClass")

			if clusterClass == nil then
				Logging.xmlError(xmlFile, "[EnhancedLivestock] Missing animal clusterClass for \'%s\'!", key)
				return
			end

			local statsBreedingName = xmlFile:getString(key .. "#statsBreeding")
			local title = g_i18n:convertText(xmlFile:getString(key .. "#groupTitle"), self.customEnvironment)
			local height = xmlFile:getFloat(key .. ".navMeshAgent#height")
			local radius = xmlFile:getFloat(key .. ".navMeshAgent#radius")
			local maxClimbMeters = xmlFile:getFloat(key .. ".navMeshAgent#maxClimbMeters")
			local maxSlope = math.rad(xmlFile:getFloat(key .. ".navMeshAgent#maxSlope") or 15)
			local sqmPerAnimal = xmlFile:getFloat(key .. ".pasture#sqmPerAnimal", 100)
			local averageBuyAge = xmlFile:getInt(key .. "#averageBuyAge", 12)
			local maxBuyAge = xmlFile:getInt(key .. "#maxBuyAge", 60)

			local averageChildren = xmlFile:getInt(key .. ".pregnancy#average", 1)
			local maxChildren = xmlFile:getInt(key .. ".pregnancy#max", 3)

			local pregnancy = {}
			local totalChance = 0

			for i = 0, averageChildren - 1 do

				totalChance = totalChance + (i / averageChildren) / maxChildren

				table.insert(pregnancy, totalChance)

			end

			totalChance = totalChance + 0.5
			table.insert(pregnancy, totalChance)

			for i = averageChildren + 1, maxChildren - 1 do

				totalChance = totalChance + (1 - totalChance) * 0.8

				table.insert(pregnancy, totalChance)

			end

			table.insert(pregnancy, 1)

			local function pregnancyFunction(value)

				for i = 0, #pregnancy - 1 do

					if pregnancy[i + 1] > value then
						return i
					end

				end

				return 0

			end

			local fertility = self:loadAnimCurve(xmlFile, key .. ".fertility")

			if fertility == nil then

				fertility = AnimCurve.new(linearInterpolator1)

				for i = 0, 120, 6 do

					fertility:addKeyframe({
						i <= 12 and 0 or (i <= 30 and (900 + i)) or (900 - i * 3),
						["time"] = i
					})

				end

				fertility:addKeyframe({
					0,
					["time"] = 121
				})

			end

			animalType = {
				["name"] = name,
				["groupTitle"] = title,
				["typeIndex"] = #self.types + 1,
				["configFilename"] = configFilename,
				["clusterClass"] = clusterClass == "AnimalCluster" and AnimalCluster or AnimalClusterHorse,
				["statsBreedingName"] = statsBreedingName,
				["navMeshAgentAttributes"] = {
					["height"] = height,
					["radius"] = radius,
					["maxClimbMeters"] = maxClimbMeters,
					["maxSlope"] = maxSlope
				},
				["sqmPerAnimal"] = sqmPerAnimal,
				["subTypes"] = {},
				["animals"] = {},
				["averageBuyAge"] = averageBuyAge,
				["maxBuyAge"] = maxBuyAge,
				["colours"] = {
					["earTagLeft"] = { 0.8, 0.7, 0 },
					["earTagRight"] = { 0.8, 0.7, 0 },
					["earTagLeft_text"] = { 0, 0, 0 },
					["earTagRight_text"] = { 0, 0, 0 }
				},
				["pregnancy"] = {
					["get"] = pregnancyFunction,
					["average"] = averageChildren
				},
				["fertility"] = fertility,
				["breeds"] = {}
			}

		end

		-- If no configFilename specified but type exists, use the existing one (set by configOverride)
		if configFilename == nil and typeAlreadyExists then
			configFilename = animalType.configFilename
			Logging.info("[EL Bridge] Using existing configFilename for type '%s': '%s'", name, configFilename)
		end

		-- Extract the config file's directory for resolving relative paths (like i3d files)
		-- This ensures paths like "highland/cattleHighland.i3d" are resolved relative to the config file,
		-- not the mod root directory
		local configDirectory = configFilename and configFilename:match("(.*[/\\])") or directory

		-- For external mods (like AnimalPackage), they may use absolute paths from mod root
		-- instead of relative paths from config file. Detect this by checking if directory != modDirectory.
		-- If we're loading from an external mod, use the base directory. Otherwise, use configDirectory.
		local assetBaseDirectory = configDirectory
		if directory ~= modDirectory then
			-- External mod: use base directory for asset resolution (paths are from mod root)
			assetBaseDirectory = directory
		end

		if self:loadAnimalConfig(animalType, assetBaseDirectory, configFilename) then

			if self:loadSubTypes(animalType, xmlFile, key, resolvedBaseDir) then

				if self.nameToType[name] == nil then

					table.insert(self.types, animalType)
					self.nameToType[name] = animalType
					self.nameToTypeIndex[name] = animalType.typeIndex
					self.typeIndexToName[animalType.typeIndex] = name

				end

			end

		end

	end

end

AnimalSystem.loadAnimals = Utils.overwrittenFunction(AnimalSystem.loadAnimals, EnhancedLivestock_AnimalSystem.loadAnimals)

function EnhancedLivestock_AnimalSystem:loadAnimalConfig(_, animalType, directory, configFilename)

	local xmlFile = XMLFile.load("animalsConfig", configFilename)

	if xmlFile == nil then
		return false
	end

	for _, key in xmlFile:iterator("animalHusbandry.animals.animal") do

		local filename = xmlFile:getString(key .. ".assets#filename")
		local filenamePosed = xmlFile:getString(key .. ".assets#filenamePosed")

		local animal = {
			["filename"] = Utils.getFilename(filename, directory),
			["filenamePosed"] = Utils.getFilename(filenamePosed, directory)
		}

		if not fileExists(animal.filename) and string.contains(filename, "dataS") then
			animal.filename = filename
		end
		if not fileExists(animal.filenamePosed) and string.contains(filenamePosed, "dataS") then
			animal.filenamePosed = filenamePosed
		end

		if animal.filenamePosed == nil then
			Logging.xmlError(xmlFile, "[EnhancedLivestock] Missing \'filenamePosed\' for animal \'%s\'", key)
			animal.filenamePosed = animal.filename
		end

		animal.variations = {}

		for _, variationKey in xmlFile:iterator(key .. ".assets.texture") do

			local variation = {}

			local numTilesU = xmlFile:getInt(variationKey .. "#numTilesU", 1)
			variation.numTilesU = math.max(numTilesU, 1)

			local tileUIndex = xmlFile:getInt(variationKey .. "#tileUIndex", 0)
			variation.tileUIndex = math.clamp(tileUIndex, 0, variation.numTilesU - 1)

			local numTilesV = xmlFile:getInt(variationKey .. "#numTilesV", 1)
			variation.numTilesV = math.max(numTilesV, 1)

			local tileVIndex = xmlFile:getInt(variationKey .. "#tileVIndex", 0)
			variation.tileVIndex = math.clamp(tileVIndex, 0, variation.numTilesV - 1)

			variation.mirrorV = xmlFile:getBool(variationKey .. "#mirrorV", false)
			variation.multi = xmlFile:getBool(variationKey .. "#multi", true)

			table.insert(animal.variations, variation)

		end

		table.insert(animalType.animals, animal)

	end

	xmlFile:delete()

	return true

end

AnimalSystem.loadAnimalConfig = Utils.overwrittenFunction(AnimalSystem.loadAnimalConfig, EnhancedLivestock_AnimalSystem.loadAnimalConfig)

function EnhancedLivestock_AnimalSystem:loadSubTypes(_, animalType, xmlFile, key, directory)

	for _, subTypeKey in xmlFile:iterator(key .. ".subType") do

		local rawName = xmlFile:getString(subTypeKey .. "#subType")
		local requiredDLC = xmlFile:getString(subTypeKey .. "#requiredDLC")

		if requiredDLC == nil or g_modNameToDirectory[g_uniqueDlcNamePrefix .. requiredDLC] ~= nil then

			if rawName == nil then
				Logging.xmlError(xmlFile, "[EnhancedLivestock] Missing animal subtype. \'%s\'", subTypeKey)
				break
			end

			local name = rawName:upper()

			if self.nameToSubTypeIndex[name] ~= nil then
				continue
			end

			local fillTypeName = xmlFile:getString(subTypeKey .. "#fillTypeName")
			local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)

			if fillTypeIndex == nil then
				Logging.xmlError(xmlFile, "[EnhancedLivestock] FillType \'%s\' for animal subtype \'%s\' not defined!", fillTypeName, subTypeKey)
				break
			end

			local subType = {
				["name"] = name,
				["subTypeIndex"] = #self.subTypes + 1,
				["fillTypeIndex"] = fillTypeIndex,
				["typeIndex"] = animalType.typeIndex,
				["statsBreedingName"] = xmlFile:getString(subTypeKey .. "#statsBreeding") or animalType.statsBreedingName
			}

			table.insert(animalType.subTypes, subType.subTypeIndex)

			if self:loadSubType(animalType, subType, xmlFile, subTypeKey, directory) then

				table.insert(self.subTypes, subType)
				self.nameToSubType[name] = subType
				self.nameToSubTypeIndex[name] = subType.subTypeIndex
				self.fillTypeIndexToSubType[fillTypeIndex] = subType

				local breed = xmlFile:getString(subTypeKey .. "#breed", name)
				subType.breed = breed

				if animalType.breeds[breed] == nil then
					animalType.breeds[breed] = {}
				end

				table.insert(animalType.breeds[breed], subType)

			end

		end

	end

	return true

end

AnimalSystem.loadSubTypes = Utils.overwrittenFunction(AnimalSystem.loadSubTypes, EnhancedLivestock_AnimalSystem.loadSubTypes)

function EnhancedLivestock_AnimalSystem:loadSubType(superFunc, animalType, subType, xmlFile, key, directory)

	local returnValue = superFunc(self, animalType, subType, xmlFile, key, directory)

	local height, radius = animalType.navMeshAgentAttributes.height, animalType.navMeshAgentAttributes.radius

	subType.gender = xmlFile:getString(key .. "#gender", "female")

	if directory ~= modDirectory and subType.gender == "female" then
		subType.gender = (string.contains(subType.name, "_MALE") or string.contains(subType.name, "BULL_") or string.contains(subType.name, "BOAR_") or string.contains(subType.name, "RAM_") or string.contains(subType.name, "BUCK_") or string.contains(subType.name, "STALLION_") or string.contains(subType.name, "ROOSTER_")) and "male" or "female"
	end

	subType.maxWeight = xmlFile:getFloat(key .. "#maxWeight", height * radius * 750)
	subType.targetWeight = xmlFile:getFloat(key .. "#targetWeight", height * radius * 300)
	subType.minWeight = xmlFile:getFloat(key .. "#minWeight", height * radius * 50)

	-- Load breed-specific tier probabilities for AI animals
	if xmlFile:hasProperty(key .. ".ai.tierProbabilities") then
		subType.tierProbabilities = {}
		xmlFile:iterate(key .. ".ai.tierProbabilities.tier", function(_, tierKey)
			local tierName = xmlFile:getString(tierKey .. "#name")
			local probability = xmlFile:getFloat(tierKey .. "#probability", 0)

			-- Map tier name to tier index
			local tierMap = {
				["YOUNG_GENOMIC"] = BullTier.YOUNG_GENOMIC,
				["PROVEN"] = BullTier.PROVEN,
				["ELITE"] = BullTier.ELITE,
				["LEGEND"] = BullTier.LEGEND
			}

			local tierIndex = tierMap[tierName]
			if tierIndex ~= nil then
				subType.tierProbabilities[tierIndex] = probability
			end
		end)
	end

	for _, visual in pairs(subType.visuals) do

		if visual.textureIndexes == nil then
			continue
		end

		local visualAnimal = table.clone(visual.visualAnimal, 10)
		visualAnimal.variations = {}

		for _, textureIndex in pairs(visual.textureIndexes) do
			table.insert(visualAnimal.variations, visual.visualAnimal.variations[textureIndex])
		end

		if #visualAnimal.variations > 0 then
			visual.visualAnimal = visualAnimal
		end

	end

	return returnValue

end

AnimalSystem.loadSubType = Utils.overwrittenFunction(AnimalSystem.loadSubType, EnhancedLivestock_AnimalSystem.loadSubType)

function EnhancedLivestock_AnimalSystem:loadVisualData(superFunc, animalType, xmlFile, key, baseDirectory)

	local visualData = superFunc(self, animalType, xmlFile, key, baseDirectory)

	if visualData == nil then
		return nil
	end

	local earTagLeft = xmlFile:getString(key .. "#earTagLeft", nil)
	local earTagRight = xmlFile:getString(key .. "#earTagRight", nil)
	local noseRing = xmlFile:getString(key .. "#noseRing", nil)
	local bumId = xmlFile:getString(key .. "#bumId", nil)
	local monitor = xmlFile:getString(key .. "#monitor", nil)
	local marker = xmlFile:getString(key .. "#marker", nil)

	-- Dynamic ear tag attachment points (for vanilla animals without embedded ear tags)
	local earTagLeftLink = xmlFile:getString(key .. "#earTagLeftLink", nil)
	local earTagRightLink = xmlFile:getString(key .. "#earTagRightLink", nil)

	-- Position/rotation/scale offsets for dynamically attached ear tags
	local earTagLeftPosition = xmlFile:getVector(key .. "#earTagLeftPosition", nil)
	local earTagLeftRotation = xmlFile:getVector(key .. "#earTagLeftRotation", nil)
	local earTagLeftScale = xmlFile:getVector(key .. "#earTagLeftScale", nil)
	local earTagRightPosition = xmlFile:getVector(key .. "#earTagRightPosition", nil)
	local earTagRightRotation = xmlFile:getVector(key .. "#earTagRightRotation", nil)
	local earTagRightScale = xmlFile:getVector(key .. "#earTagRightScale", nil)

	if earTagLeft ~= nil then
		visualData.earTagLeft = earTagLeft
	end
	if earTagRight ~= nil then
		visualData.earTagRight = earTagRight
	end
	if noseRing ~= nil then
		visualData.noseRing = noseRing
	end
	if bumId ~= nil then
		visualData.bumId = bumId
	end
	if monitor ~= nil then
		visualData.monitor = monitor
	end
	if marker ~= nil then
		visualData.marker = marker
	end

	-- Store dynamic ear tag link data
	if earTagLeftLink ~= nil then
		visualData.earTagLeftLink = earTagLeftLink
		visualData.earTagLeftPosition = earTagLeftPosition
		visualData.earTagLeftRotation = earTagLeftRotation
		visualData.earTagLeftScale = earTagLeftScale
	end
	if earTagRightLink ~= nil then
		visualData.earTagRightLink = earTagRightLink
		visualData.earTagRightPosition = earTagRightPosition
		visualData.earTagRightRotation = earTagRightRotation
		visualData.earTagRightScale = earTagRightScale
	end

	if xmlFile:hasProperty(key .. ".textureIndexes") then

		visualData.textureIndexes = {}

		xmlFile:iterate(key .. ".textureIndexes.value", function(_, textureKey)

			table.insert(visualData.textureIndexes, xmlFile:getInt(textureKey, 1))

		end)

	end

	return visualData

end

AnimalSystem.loadVisualData = Utils.overwrittenFunction(AnimalSystem.loadVisualData, EnhancedLivestock_AnimalSystem.loadVisualData)

function AnimalSystem:initialiseCountries()

	self.maxDealerAnimals = self.maxDealerAnimals or 40
	self.countries = {}
	self.animals = {}
	self.aiAnimals = {}

	for _, animalType in pairs(self.types) do
		self.animals[animalType.typeIndex] = {}
		self.aiAnimals[animalType.typeIndex] = {}
	end

	for countryIndex, country in pairs(EnhancedLivestock.AREA_CODES) do

		self.countries[countryIndex] = {
			["index"] = countryIndex,
			["farms"] = {}
		}

	end

	MoneyType.MONITOR_SUBSCRIPTIONS = MoneyType.register("monitorSubscriptions", "el_ui_monitorSubscriptions")
	MoneyType.LAST_ID = MoneyType.LAST_ID + 1

	if self.isServer then
		g_messageCenter:subscribe(MessageType.HOUR_CHANGED, self.onHourChanged, self)
	end
	g_messageCenter:subscribe(MessageType.DAY_CHANGED, self.onDayChanged, self)
	g_messageCenter:subscribe(MessageType.PERIOD_CHANGED, self.onPeriodChanged, self)

end

function AnimalSystem:validateFarms(hasData)

	if self.countries == nil then
		self.countries = {}
	end

	local animalTypeIndexes = {}

	for _, animalType in pairs(self.types) do
		table.insert(animalTypeIndexes, animalType.typeIndex)
	end


	-- validate every country exists


	for countryIndex, info in pairs(EnhancedLivestock.AREA_CODES) do

		if self.countries[countryIndex] == nil then

			self.countries[countryIndex] = {
				["index"] = countryIndex,
				["farms"] = {}
			}

		end

	end


	-- validate all countries have at least 20 unique farms

	local mapCountryIndex = EnhancedLivestock.getMapCountryIndex()

	for _, country in pairs(self.countries) do

		local farmIds = {}
		local farmsRequireId = {}

		if country.index == mapCountryIndex then

			for i, farm in pairs(g_farmManager.farms) do

				local statistics = farm.stats.statistics

				if statistics.farmId ~= nil then
					table.insert(farmIds, statistics.farmId)
				end

			end

		end

		local isFirstCreation = #country.farms == 0

		if #country.farms < 20 then

			for i = #country.farms + 1, 20 do

				local farm = { ["quality"] = math.random(250, 1750) / 1000, ["ids"] = {} }

				farm.semenPrice = (math.random(75, 125) / 100) * farm.quality

				for i = 0, math.random(0, math.min(3, #animalTypeIndexes)) do

				--local randomProduce = math.random()
				--local baseChance = 1 / (5 - i)

				--if farm.cowId == nil and randomProduce <= baseChance then
				--    farm.cowId = 0
				--elseif farm.pigId == nil and randomProduce <= baseChance * (farm.cowId == nil and 2 or 1) then
				--    farm.pigId = 0
				--elseif farm.sheepId == nil and randomProduce <= baseChance * ((farm.cowId == nil and farm.pigId == nil and 3) or ((farm.cowId == nil or farm.pigId == nil) and 2) or 1) then
				--    farm.sheepId = 0
				--elseif farm.chickenId == nil and randomProduce <= baseChance * ((farm.cowId == nil and farm.pigId == nil and farm.sheepId == nil and 4) or (i == 1 and farm.horseId == nil and 3) or 2) then
				--    farm.chickenId = 0
				--else
				--    farm.horseId = 0
				--end

					local randomAnimalTypeIndex = animalTypeIndexes[math.random(1, #animalTypeIndexes)]
					local attempts = 0

					while farm.ids[randomAnimalTypeIndex] ~= nil do

						randomAnimalTypeIndex = animalTypeIndexes[math.random(1, #animalTypeIndexes)]
						attempts = attempts + 1

						if attempts > 20 then
							break
						end

					end

					farm.ids[randomAnimalTypeIndex] = 0

				end

				table.insert(country.farms, farm)

			end

			if isFirstCreation and country.index == mapCountryIndex then

			-- validate there is at least 1 farm that produces each animal type

				for i = 1, #animalTypeIndexes do

					local randomFarmIndex = math.random(1, #country.farms)
					country.farms[randomFarmIndex].ids[i] = country.farms[randomFarmIndex].ids[i] or 0

				--if i == 1 then country.farms[randomFarmIndex].cowId = country.farms[randomFarmIndex].cowId or 0 end
				--if i == 2 then country.farms[randomFarmIndex].pigId = country.farms[randomFarmIndex].pigId or 0 end
				--if i == 3 then country.farms[randomFarmIndex].sheepId = country.farms[randomFarmIndex].sheepId or 0 end
				--if i == 4 then country.farms[randomFarmIndex].chickenId = country.farms[randomFarmIndex].chickenId or 0 end
				--if i == 5 then country.farms[randomFarmIndex].horseId = country.farms[randomFarmIndex].horseId or 0 end

				end

			end

		end

		for i, farm in pairs(country.farms) do
			if farm.id ~= nil then
				table.insert(farmIds, farm.id)
			else
				table.insert(farmsRequireId, i)
			end
		end

		for _, farmIndex in pairs(farmsRequireId) do

			local farmId = math.random(100000, 999999)

			while table.find(farmIds, farmId) ~= nil do
				farmId = math.random(100000, 999999)
			end

			country.farms[farmIndex].id = farmId
			table.insert(farmIds, farmId)

		end

	end



	-- validate there are at least 25 animals of each type for sale

	if not hasData then

		for animalTypeIndex, animals in pairs(self.animals) do

			if #animals < self.maxDealerAnimals then

				for i = #animals + 1, self.maxDealerAnimals do

					local animal = self:createNewSaleAnimal(animalTypeIndex)

					if animal ~= nil then
						table.insert(animals, animal)
					end

				end

			end

			self.animals[animalTypeIndex] = animals

		end

		for animalTypeIndex, animals in pairs(self.aiAnimals) do

			if #animals < 15 then

				for i = #animals + 1, 15 do

					local animal = self:createNewAIAnimal(animalTypeIndex)

					if animal ~= nil then
						table.insert(animals, animal)
					end

				end

			end

			self.aiAnimals[animalTypeIndex] = animals

		end

	end

end

function AnimalSystem:loadColourConfigurations()

	local savegameIndex = g_careerScreen.savegameList.selectedIndex
	local savegame = g_savegameController:getSavegame(savegameIndex)

	if savegame == nil or savegame.savegameDirectory == nil then
		return false
	end

	local xmlFile = XMLFile.loadIfExists("elAnimalSystem", savegame.savegameDirectory .. "/elAnimalSystem.xml")
	local rootKey = "elAnimalSystem"

	if xmlFile == nil then
	-- Fall back to legacy filename
		xmlFile = XMLFile.loadIfExists("animalSystem", savegame.savegameDirectory .. "/animalSystem.xml")
		rootKey = "animalSystem"
	end

	if xmlFile == nil then
		return false
	end

	xmlFile:iterate(rootKey .. ".animalTypes.type", function(_, key)

		local name = xmlFile:getString(key .. "#name")
		local earTagLeft = xmlFile:getVector(key .. "#earTagLeft", { 0.8, 0.7, 0 })
		local earTagRight = xmlFile:getVector(key .. "#earTagRight", { 0.8, 0.7, 0 })
		local earTagLeftText = xmlFile:getVector(key .. "#earTagLeftText", { 0, 0, 0 })
		local earTagRightText = xmlFile:getVector(key .. "#earTagRightText", { 0, 0, 0 })

		if self.nameToType[name] ~= nil then
			self.nameToType[name].colours.earTagLeft = earTagLeft
			self.nameToType[name].colours.earTagRight = earTagRight
			self.nameToType[name].colours.earTagLeft_text = earTagLeftText
			self.nameToType[name].colours.earTagRight_text = earTagRightText
		end

	end)

	xmlFile:delete()

end

function AnimalSystem:loadFromXMLFile()

	if g_currentMission.missionInfo == nil or g_currentMission.missionInfo.savegameDirectory == nil then
		return
	end

	local savegameDir = g_currentMission.missionInfo.savegameDirectory

	-- Try new filename first, fall back to old filename (migration support)
	local xmlFile = XMLFile.loadIfExists("elAnimalSystem", savegameDir .. "/elAnimalSystem.xml")
	local rootKey = "elAnimalSystem"

	if xmlFile == nil then
	-- Fall back to legacy filename
		xmlFile = XMLFile.loadIfExists("animalSystem", savegameDir .. "/animalSystem.xml")
		rootKey = "animalSystem"
	end

	if xmlFile == nil then return false end


	local hasData = false


	xmlFile:iterate(rootKey .. ".countries.country", function(_, key)

		local countryIndex = xmlFile:getInt(key .. "#index")

		local farms = self.countries[countryIndex].farms

		xmlFile:iterate(key .. ".farm", function(_, farmKey)

			hasData = true

			local farmId = xmlFile:getInt(farmKey .. "#id")
			local cowId = xmlFile:getInt(farmKey .. "#cowId", nil)
			local pigId = xmlFile:getInt(farmKey .. "#pigId", nil)
			local sheepId = xmlFile:getInt(farmKey .. "#sheepId", nil)
			local horseId = xmlFile:getInt(farmKey .. "#horseId", nil)
			local chickenId = xmlFile:getInt(farmKey .. "#chickenId", nil)
			local quality = xmlFile:getFloat(farmKey .. "#quality", math.random(250, 1750) / 1000)
			local semenPrice = xmlFile:getFloat(farmKey .. "#semenPrice", (math.random(75, 125) / 100) * quality)

			local ids = {}

			-- compatibility with previous builds

			if cowId ~= nil then
				ids[1] = cowId
			end
			if pigId ~= nil then
				ids[2] = pigId
			end
			if sheepId ~= nil then
				ids[3] = sheepId
			end
			if horseId ~= nil then
				ids[4] = horseId
			end
			if chickenId ~= nil then
				ids[5] = chickenId
			end

			xmlFile:iterate(farmKey .. ".id", function(_, idKey)

				local animalTypeIndex = xmlFile:getInt(idKey .. "#type", 1)
				local lastId = xmlFile:getInt(idKey .. "#id", 0)

				ids[animalTypeIndex] = lastId

			end)

			--table.insert(farms, { ["id"] = farmId, ["quality"] = quality, ["cowId"] = cowId, ["pigId"] = pigId, ["sheepId"] = sheepId, ["horseId"] = horseId, ["chickenId"] = chickenId })
			table.insert(farms, { ["id"] = farmId, ["quality"] = quality, ["ids"] = ids, ["semenPrice"] = semenPrice })

		end)

		self.countries[countryIndex].farms = farms

	end)

	xmlFile:iterate(rootKey .. ".animals.animal", function(_, key)

		local animal = Animal.loadFromXMLFile(xmlFile, key)

		if animal ~= nil then
			local animalTypeIndex = animal.animalTypeIndex

			animal.sale = {
				["day"] = xmlFile:getInt(key .. ".sale#day", 1),
				--["month"] = xmlFile:getInt(key .. ".sale#month"),
				--["year"] = xmlFile:getInt(key .. ".sale#year")
			}

			table.insert(self.animals[animalTypeIndex], animal)
		end

	end)

	xmlFile:iterate(rootKey .. ".aiAnimals.animal", function(_, key)

		local animal = Animal.loadFromXMLFile(xmlFile, key)

		if animal ~= nil then

			animal.favouritedBy = {}
			animal.success = xmlFile:getFloat(key .. "#success", 0.65)
			animal.isAIAnimal = true

			-- Load bull tier data
			animal.bullTier = xmlFile:getInt(key .. "#bullTier", BullTier.PROVEN)
			animal.availableStraws = xmlFile:getInt(key .. "#availableStraws", nil)
			animal.maxStrawsPerPurchase = xmlFile:getInt(key .. "#maxStrawsPerPurchase", nil)
			animal.lastRestockDay = xmlFile:getInt(key .. "#lastRestockDay", 0)

			-- Initialize stock if not loaded (for backward compatibility)
			if animal.availableStraws == nil and animal.bullTier ~= nil then
				local limits = BullTierStockLimits[animal.bullTier]
				if limits ~= nil then
					animal.availableStraws = limits.initialStock
					animal.maxStrawsPerPurchase = limits.maxPerPurchase
					animal.lastRestockDay = 0
				end
			end

			xmlFile:iterate(key .. ".favourites.player", function(_, favKey)
				local userId = xmlFile:getString(favKey .. "#userId", nil)
				local value = xmlFile:getBool(favKey .. "#value", false)
				if userId ~= nil then
					animal.favouritedBy[userId] = value
				end
			end)

			local animalTypeIndex = animal.animalTypeIndex
			table.insert(self.aiAnimals[animalTypeIndex], animal)

		end

	end)

	xmlFile:delete()

	return hasData

end

function AnimalSystem:saveToXMLFile(_)

	local savegameDir = g_currentMission.missionInfo.savegameDirectory
	if savegameDir == nil then return end

	local newPath = savegameDir .. "/elAnimalSystem.xml"
	local xmlFile = XMLFile.create("elAnimalSystem", newPath, "elAnimalSystem")
	if xmlFile == nil then return end

	-- Add version attribute for future migrations
	xmlFile:setInt("elAnimalSystem#version", 1)

	xmlFile:setSortedTable("elAnimalSystem.animalTypes.type", self.types, function(key, type)

		xmlFile:setString(key .. "#name", type.name)
		xmlFile:setVector(key .. "#earTagLeft", type.colours.earTagLeft)
		xmlFile:setVector(key .. "#earTagLeftText", type.colours.earTagLeft_text)
		xmlFile:setVector(key .. "#earTagRight", type.colours.earTagRight)
		xmlFile:setVector(key .. "#earTagRightText", type.colours.earTagRight_text)

	end)

	xmlFile:setSortedTable("elAnimalSystem.countries.country", self.countries, function(key, country)

		xmlFile:setInt(key .. "#index", country.index)

		for i = 1, #country.farms do

			local farmKey = string.format("%s.farm(%d)", key, i - 1)
			local farm = country.farms[i]

			xmlFile:setInt(farmKey .. "#id", farm.id)
			xmlFile:setFloat(farmKey .. "#quality", farm.quality)
			xmlFile:setFloat(farmKey .. "#semenPrice", farm.semenPrice)

			local j = 0

			for animalTypeIndex, id in pairs(farm.ids) do

				local idKey = farmKey .. ".id( " .. j .. ")"

				xmlFile:setInt(idKey .. "#type", animalTypeIndex)
				xmlFile:setInt(idKey .. "#id", id)

				j = j + 1

			end

		end

	end)

	local allAnimals = {}

	for _, animals in pairs(self.animals) do

		for _, animal in pairs(animals) do
			if animal.sale ~= nil and animal.sale.day ~= nil then
				table.insert(allAnimals, animal)
			end
		end

	end

	xmlFile:setSortedTable("elAnimalSystem.animals.animal", allAnimals, function(key, animal)

		animal:saveToXMLFile(xmlFile, key)
		xmlFile:setInt(key .. ".sale#day", animal.sale.day)
	--xmlFile:setInt(key .. ".sale#month", animal.sale.month)
	--xmlFile:setInt(key .. ".sale#year", animal.sale.year)

	end)

	local allAIAnimals = {}

	for _, animals in pairs(self.aiAnimals) do

		for _, animal in pairs(animals) do
			table.insert(allAIAnimals, animal)
		end

	end

	xmlFile:setSortedTable("elAnimalSystem.aiAnimals.animal", allAIAnimals, function(key, animal)

		animal:saveToXMLFile(xmlFile, key)

		xmlFile:setFloat(key .. "#success", animal.success or 0.65)

		-- Save bull tier data
		if animal.bullTier ~= nil then
			xmlFile:setInt(key .. "#bullTier", animal.bullTier)
		end
		if animal.availableStraws ~= nil then
			xmlFile:setInt(key .. "#availableStraws", animal.availableStraws)
		end
		if animal.maxStrawsPerPurchase ~= nil then
			xmlFile:setInt(key .. "#maxStrawsPerPurchase", animal.maxStrawsPerPurchase)
		end
		if animal.lastRestockDay ~= nil then
			xmlFile:setInt(key .. "#lastRestockDay", animal.lastRestockDay)
		end

		local i = 0

		for userId, value in pairs(animal.favouritedBy) do

			if not value then
				continue
			end

			local favKey = string.format("%s.favourites.player(%s)", key, i)
			xmlFile:setString(favKey .. "#userId", userId)
			xmlFile:setBool(favKey .. "#value", true)

			i = i + 1

		end

	end)

	xmlFile:save(false, true)
	xmlFile:delete()

end

function AnimalSystem:createNewSaleAnimal(animalTypeIndex)

	local animalType = self:getTypeByIndex(animalTypeIndex)

	if animalType == nil then
		return nil
	end

	local subTypeIndex = animalType.subTypes[math.random(1, #animalType.subTypes)]
	local subType = self:getSubTypeByIndex(subTypeIndex)

	local farmId, farmQuality, farmCountryIndex, lastAnimalId
	local attemptedCountryIndexes = {}

	while farmId == nil do

		if #attemptedCountryIndexes == #self.countries then
			return nil
		end

		local countryIndex

		if #attemptedCountryIndexes == 0 and math.random() >= 0.12 then
			countryIndex = EnhancedLivestock.getMapCountryIndex()
		else
			countryIndex = math.random(1, #self.countries)
			while table.find(attemptedCountryIndexes, countryIndex) ~= nil do
				countryIndex = math.random(1, #self.countries)
			end
		end

		table.insert(attemptedCountryIndexes, countryIndex)

		local country = self.countries[countryIndex]
		local validFarms = {}

		for i = 1, #country.farms do

			local farm = country.farms[i]

			--if animalTypeIndex == AnimalType.COW and farm.cowId ~= nil then
			--    table.insert(validFarms, i)
			--    continue
			--end

			--if animalTypeIndex == AnimalType.PIG and farm.pigId ~= nil then
			--    table.insert(validFarms, i)
			--    continue
			--end

			--if animalTypeIndex == AnimalType.SHEEP and farm.sheepId ~= nil then
			--    table.insert(validFarms, i)
			--    continue
			--end

			--if animalTypeIndex == AnimalType.CHICKEN and farm.chickenId ~= nil then
			--    table.insert(validFarms, i)
			--    continue
			--end

			--if animalTypeIndex == AnimalType.HORSE and farm.horseId ~= nil then
			--    table.insert(validFarms, i)
			--end

			if farm.ids[animalTypeIndex] ~= nil then
				table.insert(validFarms, i)
			end

		end

		if #validFarms == 0 then
			continue
		end

		local farmIndex = validFarms[math.random(1, #validFarms)]
		local farm = country.farms[farmIndex]

		farmId = farm.id
		farmQuality = farm.quality
		farmCountryIndex = countryIndex

		--if animalTypeIndex == AnimalType.COW then
		--    country.farms[farmIndex].cowId = farm.cowId + 1
		--    lastAnimalId = country.farms[farmIndex].cowId
		--elseif animalTypeIndex == AnimalType.PIG then
		--    country.farms[farmIndex].pigId = farm.pigId + 1
		--    lastAnimalId = country.farms[farmIndex].pigId
		--elseif animalTypeIndex == AnimalType.SHEEP then
		--    country.farms[farmIndex].sheepId = farm.sheepId + 1
		--    lastAnimalId = country.farms[farmIndex].sheepId
		--elseif animalTypeIndex == AnimalType.CHICKEN then
		--    country.farms[farmIndex].chickenId = farm.chickenId + 1
		--    lastAnimalId = country.farms[farmIndex].chickenId
		--elseif animalTypeIndex == AnimalType.HORSE then
		--    country.farms[farmIndex].horseId = farm.horseId + 1
		--    lastAnimalId = country.farms[farmIndex].horseId
		--end

		farm.ids[animalTypeIndex] = (farm.ids[animalTypeIndex] or 0) + 1
		lastAnimalId = farm.ids[animalTypeIndex]

	end

	local averageBuyAge = animalType.averageBuyAge or 12
	local maxBuyAge = animalType.maxBuyAge or 60
	local age

	if math.random() >= 0.5 then

		age = math.random(averageBuyAge * 0.85, averageBuyAge * 1.15)

	elseif math.random() >= 0.25 then

		age = math.random(0, averageBuyAge * 0.85)

	else

		age = math.random(averageBuyAge * 1.15, maxBuyAge)

	end

	age = math.clamp(age, 0, maxBuyAge)
	local viableReproductionMonths = age - (subType.reproductionMinAgeMonth + subType.reproductionDurationMonth)
	local isParent, isPregnant, monthsSinceLastBirth = false, false, 12
	local animalGender = subType.gender

	if viableReproductionMonths >= 0 and math.random(0, 100) <= viableReproductionMonths then
		isParent = true
		monthsSinceLastBirth = math.random(0, viableReproductionMonths)
	end

	if animalGender == "female" and age - subType.reproductionMinAgeMonth >= 0 and math.random() >= 0.95 then
		isPregnant = true
	end

	local uniqueId = tostring(lastAnimalId)
	local idLen = string.len(uniqueId)

	if idLen < 5 then
		if idLen == 1 then
			uniqueId = "1000" .. uniqueId
		elseif idLen == 2 then
			uniqueId = "100" .. uniqueId
		elseif idLen == 3 then
			uniqueId = "10" .. uniqueId
		elseif idLen == 4 then
			uniqueId = "1" .. uniqueId
		end
	end

	local concatenatedId = farmId .. uniqueId
	local checkDigit = (tonumber(concatenatedId)
	:: number % 7) + 1
	uniqueId = checkDigit .. uniqueId


	local geneticsModifier = farmQuality * 1000
	local genetics = {
		["metabolism"] = math.clamp(math.random(geneticsModifier - 300, geneticsModifier + 300) / 1000, 0.25, 1.75),
		["quality"] = math.clamp(math.random(geneticsModifier - 300, geneticsModifier + 300) / 1000, 0.25, 1.75),
		["fertility"] = math.clamp(math.random(geneticsModifier - 300, geneticsModifier + 300) / 1000, 0.25, 1.75),
		["health"] = math.clamp(math.random(geneticsModifier - 300, geneticsModifier + 300) / 1000, 0.25, 1.75)
	}

	if animalTypeIndex == AnimalType.COW or animalTypeIndex == AnimalType.SHEEP or animalTypeIndex == AnimalType.CHICKEN then
		genetics.productivity = math.clamp(math.random(geneticsModifier - 300, geneticsModifier + 300) / 1000, 0.25, 1.75)
	end


	local name

	if math.random() >= 0.85 then
		name = g_currentMission.animalNameSystem:getRandomName(animalGender)
	end


	local animal = Animal.new(age, math.clamp((math.random(650, 1000) / 10) * genetics.health, 0, 100), monthsSinceLastBirth, animalGender, subTypeIndex, 0, isParent, isPregnant, animalTypeIndex == AnimalType.COW and animalGender == "female" and isParent and monthsSinceLastBirth < 10, nil, nil, nil, nil, nil, name, nil, nil, nil, nil, nil, genetics)

	animal.farmId = tostring(farmId)
	animal.uniqueId = uniqueId
	animal.birthday.country = farmCountryIndex

	local variations = self:getVisualByAge(subTypeIndex, age).visualAnimal.variations
	local variationIndex = 1

	if #variations > 1 then
		variationIndex = math.random(1, #variations)
	end

	animal.variation = variationIndex

	local environment = g_currentMission.environment
	local month = environment.currentPeriod + 2

	if month > 12 then
		month = month - 12
	end

	local day = 1 + math.floor((environment.currentDayInPeriod - 1) * (getDaysInMonth(month) / environment.daysPerPeriod))
	local year = environment.currentYear


	animal.diseases = {}

	if g_diseaseManager ~= nil then
		g_diseaseManager:onDayChanged(animal)
		g_diseaseManager:setGeneticDiseasesForSaleAnimal(animal)
	else
		Logging.warning("[EnhancedLivestock] g_diseaseManager is nil while generating sale animal - disease system failed to initialize")
	end


	if isPregnant then

		local childNum = animal:generateRandomOffspring()
		local children = {}

		local minMetabolism, maxMetabolism = genetics.metabolism * 0.9, genetics.metabolism * 1.1
		local minMeat, maxMeat = genetics.quality * 0.9, genetics.quality * 1.1
		local minHealth, maxHealth = genetics.health * 0.9, genetics.health * 1.1
		local minFertility, maxFertility = genetics.fertility * 0.9, genetics.fertility * 1.1
		local minProductivity, maxProductivity

		if genetics.productivity ~= nil then
			minProductivity, maxProductivity = genetics.productivity * 0.9, genetics.productivity * 1.1
		end

		for i = 1, childNum do

			local gender = math.random() >= 0.5 and "male" or "female"
			local childSubTypeIndex = subTypeIndex + (gender == "male" and 1 or 0)


			local child = Animal.new(-1, 100, 0, gender, childSubTypeIndex, 0, false, false, false, nil, nil, animal.farmId .. " " .. animal.uniqueId)

			local metabolism = math.random(minMetabolism * 100, maxMetabolism * 100) / 100
			local quality = math.random(minMeat * 100, maxMeat * 100) / 100
			local healthGenetics = math.random(minHealth * 100, maxHealth * 100) / 100
			local fertility = math.random(minFertility * 100, maxFertility * 100) / 100
			local productivity = nil

			if genetics.productivity ~= nil then
				productivity = math.clamp(math.random(minProductivity * 100, maxProductivity * 100) / 100, 0.25, 1.75)
			end


			child:setGenetics({
				["metabolism"] = math.clamp(metabolism, 0.25, 1.75),
				["quality"] = math.clamp(quality, 0.25, 1.75),
				["health"] = math.clamp(healthGenetics, 0.25, 1.75),
				["fertility"] = math.clamp(fertility, 0.25, 1.75),
				["productivity"] = productivity
			})


			for _, disease in pairs(animal.diseases) do

				disease:affectReproduction(child)

			end


			table.insert(children, child)

		end


		local reproductionDuration = subType.reproductionDurationMonth

		if math.random() >= 0.99 then

			if math.random() >= 0.95 then
				reproductionDuration = reproductionDuration + math.random() >= 0.75 and -2 or 2
			else
				reproductionDuration = reproductionDuration + math.random() >= 0.85 and -1 or 1
			end

			reproductionDuration = math.max(reproductionDuration, 2)

		end

		local expectedYear = year + math.floor(reproductionDuration / 12)
		local expectedMonth = month + (reproductionDuration % 12)

		while expectedMonth > 12 do
			expectedMonth = expectedMonth - 12
			expectedYear = expectedYear + 1
		end

		local expectedDay = math.random(1, getDaysInMonth(expectedMonth))

		if #children > 0 then

			animal.pregnancy = {
				["duration"] = reproductionDuration,
				["expected"] = {
					["day"] = expectedDay,
					["month"] = expectedMonth,
					["year"] = expectedYear
				},
				["pregnancies"] = children
			}

		end

	end

	animal.sale = {
		--["day"] = day,
		--["month"] = month,
		--["year"] = year
		["day"] = environment.currentMonotonicDay
	}

	if animal.reproduction > 0 and (animal.pregnancy == nil or #animal.pregnancy.pregnancies == 0) then
		animal.reproduction = 0
		animal.pregnancy = nil
	end

	return animal

end

function AnimalSystem:getSaleAnimalsByTypeIndex(animalTypeIndex)

	if self.animals == nil then
		return {}
	end

	return self.animals[animalTypeIndex] or {}

end

function AnimalSystem:getAIAnimalsByTypeIndex(animalTypeIndex)

	if self.aiAnimals == nil then
		return {}
	end

	return self.aiAnimals[animalTypeIndex] or {}

end

function AnimalSystem:getFarmQuality(country, farmId)

	if self.countries[country] ~= nil then

		local farms = self.countries[country].farms

		if type(farmId) == "string" then
			farmId = tonumber(farmId)
		end

		for _, farm in pairs(farms) do

			if farm.id == farmId then
				return farm.quality
			end

		end

	end

	return 1

end

function AnimalSystem:getFarmSemenPrice(country, farmId)

	if self.countries[country] ~= nil then

		local farms = self.countries[country].farms

		if type(farmId) == "string" then
			farmId = tonumber(farmId)
		end

		for _, farm in pairs(farms) do

			if farm.id == farmId then
				return farm.semenPrice
			end

		end

	end

	return 1

end

function AnimalSystem:getNextAnimalIdForFarm(countryIndex, animalTypeIndex, farmId)

	local country = self.countries[countryIndex]

	if country == nil then
		return 1
	end

	local farms = country.farms

	if type(farmId) == "string" then
		farmId = tonumber(farmId)
	end

	for _, farm in pairs(farms) do

		if farm.id == farmId then

		--local index = "cowId"

		--if animalTypeIndex == AnimalType.PIG then
		--    index = "pigId"
		--elseif animalTypeIndex == AnimalType.SHEEP then
		--    index = "sheepId"
		--elseif animalTypeIndex == AnimalType.CHICKEN then
		--    index = "chickenId"
		--elseif animalTypeIndex == AnimalType.HORSE then
		--    index = "horseId"
		--end

		--if farm[index] ~= nil then
		--    farm[index] = farm[index] + 1
		--    return farm[index]
		--end

			if farm.ids[animalTypeIndex] ~= nil then

				farm.ids[animalTypeIndex] = farm.ids[animalTypeIndex] + 1
				return farm.ids[animalTypeIndex]

			end

			return 1

		end

	end

	return 1

end

function AnimalSystem:removeSaleAnimal(animalTypeIndex, countryIndex, farmId, uniqueId)

	for i, animal in pairs(self.animals[animalTypeIndex]) do

		if animal.birthday.country == countryIndex and animal.farmId == farmId and animal.uniqueId == uniqueId then
			table.remove(self.animals[animalTypeIndex], i)
			return
		end

	end

end

function AnimalSystem:removeAIAnimal(animalTypeIndex, countryIndex, farmId, uniqueId)

	for i, animal in pairs(self.aiAnimals[animalTypeIndex]) do

		if animal.birthday.country == countryIndex and animal.farmId == farmId and animal.uniqueId == uniqueId then
			table.remove(self.aiAnimals[animalTypeIndex], i)
			return
		end

	end

end

function AnimalSystem:onHourChanged()

	local day = g_currentMission.environment.currentMonotonicDay
	local hasChanges = false

	for animalTypeIndex, animals in pairs(self.animals) do

		local indexesToRemove = {}

		for i, animal in pairs(animals) do

			if animal.sale ~= nil then

				local saleDay = animal.sale.day

				if saleDay == day then
					continue
				end

				local geneticQuality = 0
				local totalGenetics = 0

				for _, value in pairs(animal.genetics) do
					if value ~= nil then
						totalGenetics = totalGenetics + 1
						geneticQuality = geneticQuality + value
					end
				end

				local averageGenetics = geneticQuality / totalGenetics

				if math.random() >= (saleDay / day) / (averageGenetics * 1.45) then
					table.insert(indexesToRemove, i)
					hasChanges = true
				end

			end

		end

		for i = #indexesToRemove, 1, -1 do
			table.remove(animals, indexesToRemove[i])
		end

		local threshold = math.random(10, self.maxDealerAnimals)

		if #animals < threshold then

			for i = #animals + 1, threshold do

				local animal = self:createNewSaleAnimal(animalTypeIndex)

				if animal ~= nil then
					table.insert(animals, animal)
					hasChanges = true
				end

			end

		end

	end

	for animalTypeIndex, animals in pairs(self.aiAnimals) do

		if #animals < 15 then

			for i = #animals + 1, 15 do

				local animal = self:createNewAIAnimal(animalTypeIndex)

				if animal ~= nil then
					table.insert(animals, animal)
					hasChanges = true
				end

			end

		end

	end

	if hasChanges then
		g_server:broadcastEvent(AnimalSystemStateEvent.new(self.countries, self.animals, self.aiAnimals))
	end

end

function AnimalSystem:onDayChanged()

	local environment = g_currentMission.environment
	local month = environment.currentPeriod + 2
	local currentDayInPeriod = environment.currentDayInPeriod

	if month > 12 then
		month = month - 12
	end

	local daysPerPeriod = environment.daysPerPeriod
	local day = 1 + math.floor((currentDayInPeriod - 1) * (getDaysInMonth(month) / daysPerPeriod))
	local year = environment.currentYear

	for _, animals in pairs(self.animals) do

		for _, animal in pairs(animals) do

			animal.reserved = false

			animal:onDayChanged(nil, self.isServer, day, month, year, currentDayInPeriod, daysPerPeriod, true)

		end

	end

	for _, animals in pairs(self.aiAnimals) do

		for _, animal in pairs(animals) do
			animal:onDayChanged(nil, self.isServer, day, month, year, currentDayInPeriod, daysPerPeriod, true)

			-- Restock AI animal semen based on tier
			if animal.bullTier ~= nil and animal.availableStraws ~= nil then
				local limits = BullTierStockLimits[animal.bullTier]
				local currentDay = environment.currentMonotonicDay

				if limits ~= nil then
					if limits.restockRate == "daily" then
						animal.availableStraws = math.min(
							animal.availableStraws + limits.restockAmount,
							limits.initialStock
						)
						animal.lastRestockDay = currentDay

					elseif limits.restockRate == "weekly" then
						if currentDay - animal.lastRestockDay >= 7 then
							animal.availableStraws = math.min(
								animal.availableStraws + limits.restockAmount,
								limits.initialStock
							)
							animal.lastRestockDay = currentDay
						end
					end
				end
			end
		end

	end

end

function AnimalSystem:onPeriodChanged()

	for _, animals in pairs(self.animals) do

		for _, animal in pairs(animals) do

			animal:onPeriodChanged()

		end

	end

	for _, animals in pairs(self.aiAnimals) do

		for _, animal in pairs(animals) do

			animal:onPeriodChanged()

		end

	end

	if self.isServer then

		local monitorCosts = {}

		for _, placeable in pairs(g_currentMission.husbandrySystem.placeables) do

			local animals = placeable:getClusters()
			local ownerFarmId = placeable:getOwnerFarmId()

			for _, animal in pairs(animals) do

				if not animal.monitor.active and not animal.monitor.removed then
					continue
				end

				if animal.monitor.removed and not animal.monitor.active then

					local visualData = self:getVisualByAge(animal.subTypeIndex, animal.age)

					if visualData.monitor ~= nil and animal.idFull ~= nil and animal.idFull ~= "1-1" then

						local sep = string.find(animal.idFull, "-")
						local husbandry = tonumber(string.sub(animal.idFull, 1, sep - 1))
						local animalId = tonumber(string.sub(animal.idFull, sep + 1))

						if husbandry ~= 0 and animalId ~= 0 then

							local rootNode = getAnimalRootNode(husbandry, animalId)

							if rootNode ~= 0 then

								local monitorNode = I3DUtil.indexToObject(rootNode, visualData.monitor)

								if monitorNode ~= nil and monitorNode ~= 0 then
									setVisibility(monitorNode, false)
								end

							end

						end

					end

					animal.monitor.removed = false

				end

				if monitorCosts[ownerFarmId] == nil then
					monitorCosts[ownerFarmId] = 0
				end

				monitorCosts[ownerFarmId] = monitorCosts[ownerFarmId] + animal.monitor.fee

			end

		end

		for ownerFarmId, cost in pairs(monitorCosts) do

			local ownerFarm = g_farmManager:getFarmById(ownerFarmId)

			g_currentMission:addMoneyChange(0 - cost, ownerFarmId, MoneyType.MONITOR_SUBSCRIPTIONS, true)
			ownerFarm:changeBalance(0 - cost, MoneyType.MONITOR_SUBSCRIPTIONS)

		end

	end

end

function AnimalSystem:addExistingSaleAnimal(animal)

	local animalTypeIndex = animal.animalTypeIndex or 0

	if self.animals[animalTypeIndex] ~= nil then
		table.insert(self.animals[animalTypeIndex], animal)
	end

end

function AnimalSystem:removeAllSaleAnimals(animalTypeIndex)

	if animalTypeIndex == nil then

		for index, animals in pairs(self.animals) do
			self.animals[index] = {}
		end

	elseif self.animals[animalTypeIndex] ~= nil then

		self.animals[animalTypeIndex] = {}

	end

end

function AnimalSystem.onSettingChanged(name, state)

	g_currentMission.animalSystem[name] = state

end

function AnimalSystem.onClickResetDealer()

	local animalSystem = g_currentMission.animalSystem

	if not animalSystem.isServer then
		return
	end

	animalSystem:removeAllSaleAnimals()

	for animalTypeIndex, animals in pairs(animalSystem.animals) do

		for i = 1, animalSystem.maxDealerAnimals do

			local animal = animalSystem:createNewSaleAnimal(animalTypeIndex)

			if animal ~= nil then
				table.insert(animals, animal)
			end

		end

		animalSystem.animals[animalTypeIndex] = animals

	end

end

function AnimalSystem:getBreedsByAnimalTypeIndex(animalTypeIndex)

	return self.types[animalTypeIndex].breeds

end

function AnimalSystem:createNewAIAnimal(animalTypeIndex)

	local animalType = self:getTypeByIndex(animalTypeIndex)

	if animalType == nil then
		return nil
	end

	local validSubTypes = {}

	for _, subTypeIndex in pairs(animalType.subTypes) do

		local subType = self:getSubTypeByIndex(subTypeIndex)

		if subType.gender == "male" then
			table.insert(validSubTypes, subType)
		end

	end

	if #validSubTypes == 0 then
		return nil
	end

	local subType = validSubTypes[math.random(1, #validSubTypes)]

	if subType == nil then
		return
	end

	local subTypeIndex = subType.subTypeIndex

	local farmId, farmQuality, farmCountryIndex, lastAnimalId
	local attemptedCountryIndexes = {}

	while farmId == nil do

		if #attemptedCountryIndexes == #self.countries then
			return nil
		end

		local countryIndex

		if #attemptedCountryIndexes == 0 and math.random() >= 0.12 then
			countryIndex = EnhancedLivestock.getMapCountryIndex()
		else
			countryIndex = math.random(1, #self.countries)
			while table.find(attemptedCountryIndexes, countryIndex) ~= nil do
				countryIndex = math.random(1, #self.countries)
			end
		end

		table.insert(attemptedCountryIndexes, countryIndex)

		local country = self.countries[countryIndex]
		local validFarms = {}

		for i = 1, #country.farms do

			local farm = country.farms[i]

			if farm.ids[animalTypeIndex] ~= nil and farm.quality >= 1.35 then
				table.insert(validFarms, i)
			end

		end

		if #validFarms == 0 then
			continue
		end

		local farmIndex = validFarms[math.random(1, #validFarms)]
		local farm = country.farms[farmIndex]

		farmId = farm.id
		farmQuality = farm.quality
		farmCountryIndex = countryIndex

		farm.ids[animalTypeIndex] = (farm.ids[animalTypeIndex] or 0) + 1
		lastAnimalId = farm.ids[animalTypeIndex]

	end

	local age = math.random(subType.reproductionMinAgeMonth, subType.reproductionMinAgeMonth * 3)

	local uniqueId = tostring(lastAnimalId)
	local idLen = string.len(uniqueId)

	if idLen < 5 then
		if idLen == 1 then
			uniqueId = "1000" .. uniqueId
		elseif idLen == 2 then
			uniqueId = "100" .. uniqueId
		elseif idLen == 3 then
			uniqueId = "10" .. uniqueId
		elseif idLen == 4 then
			uniqueId = "1" .. uniqueId
		end
	end

	local concatenatedId = farmId .. uniqueId
	local checkDigit = (tonumber(concatenatedId)
	:: number % 7) + 1
	uniqueId = checkDigit .. uniqueId

	-- Step 1: Assign bull tier based on farm quality
	-- Higher quality farms produce better tier bulls
	local baseTierProbabilities = subType.tierProbabilities or {
		[BullTier.YOUNG_GENOMIC] = 0.50,
		[BullTier.PROVEN] = 0.35,
		[BullTier.ELITE] = 0.13,
		[BullTier.LEGEND] = 0.02
	}

	-- Adjust probabilities based on farm quality (quality ranges from ~1.35 to ~1.75)
	-- Higher quality shifts probability toward better tiers
	local qualityFactor = math.clamp((farmQuality - 1.35) / (1.75 - 1.35), 0, 1)  -- Normalize to [0, 1]

	local tierProbabilities = {
		[BullTier.YOUNG_GENOMIC] = baseTierProbabilities[BullTier.YOUNG_GENOMIC] * (1 - qualityFactor * 0.4),
		[BullTier.PROVEN] = baseTierProbabilities[BullTier.PROVEN],
		[BullTier.ELITE] = baseTierProbabilities[BullTier.ELITE] * (1 + qualityFactor * 1.5),
		[BullTier.LEGEND] = baseTierProbabilities[BullTier.LEGEND] * (1 + qualityFactor * 3.0)
	}

	-- Normalize probabilities to sum to 1.0
	local totalProb = 0
	for _, prob in pairs(tierProbabilities) do
		totalProb = totalProb + prob
	end
	for tier, prob in pairs(tierProbabilities) do
		tierProbabilities[tier] = prob / totalProb
	end

	local bullTier = BullTier.PROVEN  -- Fallback default
	local tierRoll = math.random()
	local cumulative = 0
	for tier = 1, 4 do
		cumulative = cumulative + (tierProbabilities[tier] or 0)
		if tierRoll <= cumulative then
			bullTier = tier
			break
		end
	end

	-- Step 2: Generate genetics directly from tier ranges
	local tierGeneticsRanges = {
		[BullTier.YOUNG_GENOMIC] = { min = 1.0, max = 1.75 },
		[BullTier.PROVEN] = { min = 1.0, max = 1.5 },
		[BullTier.ELITE] = { min = 1.30, max = 1.6 },
		[BullTier.LEGEND] = { min = 1.6, max = 1.75 }
	}

	local range = tierGeneticsRanges[bullTier]
	local genetics = {
		["metabolism"] = math.clamp(math.random(range.min * 100, range.max * 100) / 100, range.min, range.max),
		["quality"] = math.clamp(math.random(range.min * 100, range.max * 100) / 100, range.min, range.max),
		["fertility"] = math.clamp(math.random(range.min * 100, range.max * 100) / 100, range.min, range.max),
		["health"] = math.clamp(math.random(range.min * 100, range.max * 100) / 100, range.min, range.max)
	}

	if animalTypeIndex == AnimalType.COW or animalTypeIndex == AnimalType.SHEEP or animalTypeIndex == AnimalType.CHICKEN then
		genetics.productivity = math.clamp(math.random(range.min * 100, range.max * 100) / 100, range.min, range.max)
	end

	local name = g_currentMission.animalNameSystem:getRandomName("male")

	-- Step 3: Create animal with tier-based genetics
	local animal = Animal.new(age, math.clamp((math.random(650, 1000) / 10) * genetics.health, 75, 100), 0, "male", subTypeIndex, 0, false, false, false, nil, nil, nil, nil, nil, name, nil, nil, nil, nil, nil, genetics)

	animal.farmId = tostring(farmId)
	animal.uniqueId = uniqueId
	animal.birthday.country = farmCountryIndex

	local variations = self:getVisualByAge(subTypeIndex, age).visualAnimal.variations
	local variationIndex = 1

	if #variations > 1 then
		variationIndex = math.random(1, #variations)
	end

	animal.variation = variationIndex

	animal.favouritedBy = {}
	animal.isAIAnimal = true
	animal.bullTier = bullTier

	-- Step 4: Calculate success rate from FINAL genetics
	-- Map fertility [1.3, 1.75] to success [~65%, ~100%] with small random variation
	-- This ensures higher fertility always results in higher success rates
	local normalizedFertility = math.clamp((genetics.fertility - 1.3) / (1.75 - 1.3), 0, 1)
	local baseSuccess = 0.65 + (normalizedFertility * 0.35)
	-- Add ±2.5% random variation to avoid identical success rates
	local variation = 0.975 + (math.random() * 0.05)
	animal.success = math.clamp(baseSuccess * variation, 0.5, 1)

	-- Initialize stock tracking
	local limits = BullTierStockLimits[animal.bullTier]
	if limits ~= nil then
		animal.availableStraws = limits.initialStock
		animal.maxStrawsPerPurchase = limits.maxPerPurchase
		animal.lastRestockDay = 0
	end

	return animal

end