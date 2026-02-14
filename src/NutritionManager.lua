NutritionManager = {}

local modDirectory = g_currentModDirectory
local nutritionManager_mt = Class(NutritionManager)

function NutritionManager.new()

	local self = setmetatable({}, nutritionManager_mt)

	self.feedProfiles = {}
	self.defaultFeed = nil
	self.lifeStages = {}
	self.pregnancyTrimesters = {}
	self.growthRates = {}
	self.troughCache = {}

	return self

end

function NutritionManager:loadFromXML(path)

	local xmlFile = XMLFile.loadIfExists("nutrition", path)

	if xmlFile == nil then
		Logging.warning("[EnhancedLivestock] NutritionManager: Could not load nutrition.xml from %s", path)
		return false
	end

	-- Load default feed profile
	local defaultEnergy = xmlFile:getFloat("nutrition.feeds.default#energy", 9.0)
	local defaultProtein = xmlFile:getFloat("nutrition.feeds.default#protein", 100)
	local defaultDM = xmlFile:getFloat("nutrition.feeds.default#dryMatterPercent", 0.50)
	local defaultFiber = xmlFile:getFloat("nutrition.feeds.default#fiber", 400)
	local defaultLitersPerKgDM = xmlFile:getFloat("nutrition.feeds.default#litersPerKgDM", 2.5)

	self.defaultFeed = {
		energy = defaultEnergy,
		protein = defaultProtein,
		dryMatterPercent = defaultDM,
		fiber = defaultFiber,
		litersPerKgDM = defaultLitersPerKgDM
	}

	-- Load feed profiles
	xmlFile:iterate("nutrition.feeds.feed", function(_, key)

		local fillTypeName = xmlFile:getString(key .. "#fillType")

		if fillTypeName == nil then
			return
		end

		local fillTypeIndex = g_fillTypeManager:getFillTypeIndexByName(fillTypeName)

		local profile = {
			fillTypeName = fillTypeName,
			category = xmlFile:getString(key .. "#category", "UNKNOWN"),
			energy = xmlFile:getFloat(key .. "#energy", defaultEnergy),
			protein = xmlFile:getFloat(key .. "#protein", defaultProtein),
			dryMatterPercent = xmlFile:getFloat(key .. "#dryMatterPercent", defaultDM),
			fiber = xmlFile:getFloat(key .. "#fiber", defaultFiber),
			litersPerKgDM = xmlFile:getFloat(key .. "#litersPerKgDM", defaultLitersPerKgDM)
		}

		if fillTypeIndex ~= nil then
			self.feedProfiles[fillTypeIndex] = profile
		end

		-- Also store by name for fill types not yet registered
		self.feedProfiles[fillTypeName] = profile

	end)

	-- Load life stages
	xmlFile:iterate("nutrition.lifeStages.species", function(_, speciesKey)

		local speciesName = xmlFile:getString(speciesKey .. "#name")

		if speciesName == nil then
			return
		end

		local stages = {}

		xmlFile:iterate(speciesKey .. ".stage", function(_, stageKey)

			local stage = {
				name = xmlFile:getString(stageKey .. "#name", "UNKNOWN"),
				minAge = xmlFile:getInt(stageKey .. "#minAge", 0),
				maxAge = xmlFile:getInt(stageKey .. "#maxAge", 999),
				gender = xmlFile:getString(stageKey .. "#gender", "any"),
				condition = xmlFile:getString(stageKey .. "#condition", "none"),
				priority = xmlFile:getInt(stageKey .. "#priority", 0),
				dmiPercent = xmlFile:getFloat(stageKey .. "#dmiPercent", 2.0),
				energyPerKgBW075 = xmlFile:getFloat(stageKey .. "#energyPerKgBW075", 0.50),
				proteinPerKgBW075 = xmlFile:getFloat(stageKey .. "#proteinPerKgBW075", 5.0)
			}

			table.insert(stages, stage)

		end)

		-- Sort by priority descending so highest priority is checked first
		table.sort(stages, function(a, b)
			return a.priority > b.priority
		end)

		self.lifeStages[speciesName] = stages

	end)

	-- Load pregnancy trimester multipliers
	xmlFile:iterate("nutrition.pregnancyTrimesters.species", function(_, speciesKey)

		local speciesName = xmlFile:getString(speciesKey .. "#name")

		if speciesName == nil then
			return
		end

		local trimesters = {}

		xmlFile:iterate(speciesKey .. ".trimester", function(_, trimKey)

			local index = xmlFile:getInt(trimKey .. "#index", 1)

			trimesters[index] = {
				energyMultiplier = xmlFile:getFloat(trimKey .. "#energyMultiplier", 1.0),
				dmiMultiplier = xmlFile:getFloat(trimKey .. "#dmiMultiplier", 1.0)
			}

		end)

		self.pregnancyTrimesters[speciesName] = trimesters

	end)

	-- Load growth rates
	xmlFile:iterate("nutrition.growthRates.species", function(_, speciesKey)

		local speciesName = xmlFile:getString(speciesKey .. "#name")

		if speciesName == nil then
			return
		end

		self.growthRates[speciesName] = {
			maxADG_male = xmlFile:getFloat(speciesKey .. "#maxADG_male", 1.0),
			maxADG_female = xmlFile:getFloat(speciesKey .. "#maxADG_female", 0.8)
		}

	end)

	xmlFile:delete()

	local feedCount = 0
	for k, _ in pairs(self.feedProfiles) do
		if type(k) == "number" then
			feedCount = feedCount + 1
		end
	end

	local speciesCount = 0
	for _ in pairs(self.lifeStages) do
		speciesCount = speciesCount + 1
	end

	Logging.info("[EnhancedLivestock] NutritionManager: Loaded %d feed profiles, %d species life stages", feedCount, speciesCount)

	return true

end

function NutritionManager:getFeedProfile(fillTypeIndex)

	if fillTypeIndex ~= nil and self.feedProfiles[fillTypeIndex] ~= nil then
		return self.feedProfiles[fillTypeIndex]
	end

	return self.defaultFeed

end

function NutritionManager:getAnimalTypeName(animal)

	local animalSystem = g_currentMission.animalSystem

	if animalSystem.typeIndexToName ~= nil then
		return animalSystem.typeIndexToName[animal.animalTypeIndex]
	end

	return nil

end

function NutritionManager:getLifeStage(animal)

	local speciesName = self:getAnimalTypeName(animal)

	if speciesName == nil then
		return nil
	end

	local stages = self.lifeStages[speciesName]

	if stages == nil then
		return nil
	end

	local age = animal.age or 0
	local gender = animal.gender or "female"

	for _, stage in ipairs(stages) do

		-- Check age range
		if age >= stage.minAge and age <= stage.maxAge then

			-- Check gender
			if stage.gender == "any" or stage.gender == gender then

				-- Check condition
				local conditionMet = true
				if stage.condition ~= "none" then
					if stage.condition == "isLactating" and not animal.isLactating then
						conditionMet = false
					elseif stage.condition == "isPregnant" and not animal.isPregnant then
						conditionMet = false
					elseif stage.condition == "isCastrated" and not animal.isCastrated then
						conditionMet = false
					end
				end

				if conditionMet then
					return stage
				end
			end
		end

	end

	-- Fallback: return last stage (lowest priority)
	return stages[#stages]

end

function NutritionManager:getPregnancyTrimester(animal)

	if not animal.isPregnant or animal.pregnancy == nil then
		return nil
	end

	local duration = animal.pregnancy.duration or 1
	local reproduction = animal.reproduction or 0

	-- reproduction goes 0-100 representing progress through pregnancy
	local progress = reproduction / 100
	local trimester

	if progress < 0.333 then
		trimester = 1
	elseif progress < 0.666 then
		trimester = 2
	else
		trimester = 3
	end

	return trimester

end

function NutritionManager:getDailyRequirements(animal)

	local stage = self:getLifeStage(animal)

	if stage == nil then
		return nil
	end

	local weight = animal.weight or 1
	local metabolism = (animal.genetics and animal.genetics.metabolism) or 1
	local foodScale = EnhancedLivestock_PlaceableHusbandryFood.foodScale or 1

	-- Daily dry matter intake
	local dmiKg = weight * (stage.dmiPercent / 100) * metabolism * foodScale

	-- Metabolic weight
	local bw075 = math.pow(weight, 0.75)

	-- Energy and protein requirements
	local energyMJ = bw075 * stage.energyPerKgBW075 * metabolism
	local proteinG = bw075 * stage.proteinPerKgBW075 * metabolism

	-- Apply pregnancy trimester multipliers
	if animal.isPregnant then
		local trimester = self:getPregnancyTrimester(animal)
		local speciesName = self:getAnimalTypeName(animal)

		if trimester ~= nil and speciesName ~= nil and self.pregnancyTrimesters[speciesName] ~= nil then
			local trimData = self.pregnancyTrimesters[speciesName][trimester]

			if trimData ~= nil then
				energyMJ = energyMJ * trimData.energyMultiplier
				proteinG = proteinG * trimData.energyMultiplier
				dmiKg = dmiKg * trimData.dmiMultiplier
			end
		end
	end

	return {
		energyMJ = energyMJ,
		proteinG = proteinG,
		dmiKg = dmiKg,
		stage = stage
	}

end

function NutritionManager:getTroughComposition(husbandry)

	if husbandry == nil then
		return nil
	end

	-- Check cache
	if self.troughCache[husbandry] ~= nil then
		return self.troughCache[husbandry]
	end

	local spec = husbandry.spec_husbandryFood

	if spec == nil then
		return nil
	end

	-- Access fill levels from the vanilla food system
	local fillLevels = spec.fillLevels

	if fillLevels == nil then
		return nil
	end

	local totalLiters = 0
	local totalDMKg = 0
	local weightedEnergy = 0
	local weightedProtein = 0
	local weightedLitersPerKgDM = 0

	for fillTypeIndex, liters in pairs(fillLevels) do

		if liters ~= nil and liters > 0 then
			local profile = self:getFeedProfile(fillTypeIndex)

			local dmKg = liters * profile.dryMatterPercent / profile.litersPerKgDM

			totalLiters = totalLiters + liters
			totalDMKg = totalDMKg + dmKg
			weightedEnergy = weightedEnergy + (dmKg * profile.energy)
			weightedProtein = weightedProtein + (dmKg * profile.protein)
			weightedLitersPerKgDM = weightedLitersPerKgDM + (dmKg * profile.litersPerKgDM)
		end

	end

	if totalDMKg <= 0 then

		local result = {
			totalLiters = 0,
			totalDMKg = 0,
			avgEnergy = 0,
			avgProtein = 0,
			avgLitersPerKgDM = self.defaultFeed.litersPerKgDM
		}

		self.troughCache[husbandry] = result
		return result

	end

	local result = {
		totalLiters = totalLiters,
		totalDMKg = totalDMKg,
		avgEnergy = weightedEnergy / totalDMKg,
		avgProtein = weightedProtein / totalDMKg,
		avgLitersPerKgDM = weightedLitersPerKgDM / totalDMKg
	}

	self.troughCache[husbandry] = result
	return result

end

function NutritionManager:calculateNutritionScore(animal, husbandry)

	local requirements = self:getDailyRequirements(animal)

	if requirements == nil then
		return nil
	end

	local composition = self:getTroughComposition(husbandry)

	if composition == nil or composition.totalDMKg <= 0 then
		return 0
	end

	-- Get number of animals in the husbandry
	local numAnimals = 1

	if husbandry.spec_husbandryAnimals ~= nil then
		local clusters = husbandry.spec_husbandryAnimals:getClusters()
		if clusters ~= nil then
			numAnimals = math.max(#clusters, 1)
		end
	end

	-- Availability ratio: is there enough DM for all animals?
	local availabilityRatio = math.min(composition.totalDMKg / (numAnimals * requirements.dmiKg), 1)

	-- Required energy and protein per kg DM
	local requiredEnergyPerKgDM = requirements.energyMJ / requirements.dmiKg
	local requiredProteinPerKgDM = requirements.proteinG / requirements.dmiKg

	-- How well does the trough composition meet requirements?
	local energyRatio = math.min(composition.avgEnergy / requiredEnergyPerKgDM, 1.2)
	local proteinRatio = math.min(composition.avgProtein / requiredProteinPerKgDM, 1.2)

	-- Nutrition score = availability * quality
	local nutritionScore = math.clamp(availabilityRatio * math.min(energyRatio, proteinRatio), 0, 1)

	return nutritionScore

end

function NutritionManager:getHourlyConsumptionLiters(animal)

	local requirements = self:getDailyRequirements(animal)

	if requirements == nil then
		return nil
	end

	-- Get the trough composition to determine litersPerKgDM conversion
	local husbandry = nil

	if animal.clusterSystem ~= nil then
		husbandry = animal.clusterSystem.owner
	end

	local composition = self:getTroughComposition(husbandry)
	local litersPerKgDM = self.defaultFeed.litersPerKgDM

	if composition ~= nil and composition.avgLitersPerKgDM > 0 then
		litersPerKgDM = composition.avgLitersPerKgDM
	end

	-- Convert daily DM kg to hourly liters
	local dailyLiters = requirements.dmiKg * litersPerKgDM
	return dailyLiters / 24

end

function NutritionManager:getHourlyWaterConsumptionLiters(animal)

	local requirements = self:getDailyRequirements(animal)

	if requirements == nil then
		return nil
	end

	-- Water intake: ~4.5 liters per kg DM consumed
	local dailyWaterLiters = requirements.dmiKg * 4.5

	-- Lactating animals need 50% more water
	if animal.isLactating then
		dailyWaterLiters = dailyWaterLiters * 1.5
	end

	return dailyWaterLiters / 24

end

function NutritionManager:updateBodyCondition(animal, nutritionScore)

	local currentCondition = animal.bodyCondition or 0.5

	-- Exponential moving average with alpha = 1/168 (~7 day window at hourly updates)
	local alpha = 1 / 168
	animal.bodyCondition = currentCondition + alpha * (nutritionScore - currentCondition)

end

function NutritionManager:getMaxADG(animal)

	local speciesName = self:getAnimalTypeName(animal)

	if speciesName == nil or self.growthRates[speciesName] == nil then
		return nil
	end

	local rates = self.growthRates[speciesName]

	if animal.gender == "male" then
		return rates.maxADG_male
	else
		return rates.maxADG_female
	end

end

function NutritionManager:clearTroughCache()

	self.troughCache = {}

end
