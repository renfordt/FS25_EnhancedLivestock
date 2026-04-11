DiseaseManager = {}

local modDirectory = g_currentModDirectory
local diseaseManager_mt = Class(DiseaseManager)

function DiseaseManager.new()

	local self = setmetatable({}, diseaseManager_mt)

	self.diseases = {}
	self.diseasesEnabled = true
	self.diseasesChance = 1

	self:loadDiseases()

	return self

end

function DiseaseManager:loadDiseases()

	local xmlFile = XMLFile.loadIfExists("diseases", modDirectory .. "xml/diseases.xml")

	if xmlFile == nil then
		return
	end

	xmlFile:iterate("diseases.disease", function(_, key)

		local title = xmlFile:getString(key .. "#title")
		local translationKey = "el_disease_" .. title
		local name = g_i18n:getText(translationKey)
		local descriptionKey = translationKey .. "_desc"
		local description = g_i18n:getText(descriptionKey)

		local animals = {}
		local animalTitles = string.split(xmlFile:getString(key .. "#animals"), " ")

		for _, animalTitle in pairs(animalTitles) do
			local animalType = AnimalType[animalTitle]
			if animalType ~= nil then
				animals[animalType] = true
			end
		end

		local valueModifier = xmlFile:getFloat(key .. "#value", 1.0)
		local transmission = xmlFile:getFloat(key .. "#transmission", 0)
		local immunity = xmlFile:getInt(key .. "#immunity", 12)

		local prerequisites = {}

		xmlFile:iterate(key .. ".prerequisites.prerequisite", function(_, prerequisiteKey)

			local valueType = xmlFile:getString(prerequisiteKey .. "#valueType", "Int")

			table.insert(prerequisites, {
				["path"] = string.split(xmlFile:getString(prerequisiteKey .. "#path"), "."),
				["value"] = XMLFile["get" .. valueType](xmlFile, prerequisiteKey .. "#value")
			})

		end)

		local probability = {}

		xmlFile:iterate(key .. ".probability.key", function(_, probabilityKey)

			table.insert(probability, {
				["age"] = xmlFile:getInt(probabilityKey .. "#age"),
				["value"] = xmlFile:getFloat(probabilityKey .. "#value")
			})

		end)

		local fatality = {}

		xmlFile:iterate(key .. ".fatality.key", function(_, fatalityKey)

			table.insert(fatality, {
				["time"] = xmlFile:getInt(fatalityKey .. "#time"),
				["value"] = xmlFile:getFloat(fatalityKey .. "#value")
			})

		end)

		local output = {}

		xmlFile:iterate(key .. ".output.fillType", function(_, outputKey)

			output[xmlFile:getString(outputKey .. "#type")] = xmlFile:getFloat(outputKey .. "#modifier")

		end)

		local treatment = {
			["cost"] = xmlFile:getFloat(key .. ".treatment#cost"),
			["duration"] = xmlFile:getInt(key .. ".treatment#duration")
		}

		if treatment.cost == nil or treatment.duration == nil then
			treatment = nil
		end

		local recovery = xmlFile:getFloat(key .. "#recovery")

		-- Load new disease attributes
		local weightGain = xmlFile:getFloat(key .. "#weightGain", 1.0)
		local fertilityModifier = xmlFile:getFloat(key .. "#fertility", 1.0)

		-- Load seasonal modifiers
		local season = nil
		if xmlFile:hasProperty(key .. ".season") then
			season = {
				spring = xmlFile:getFloat(key .. ".season#spring", 1.0),
				summer = xmlFile:getFloat(key .. ".season#summer", 1.0),
				autumn = xmlFile:getFloat(key .. ".season#autumn", 1.0),
				winter = xmlFile:getFloat(key .. ".season#winter", 1.0)
			}
		end

		local disease = {
			["title"] = title,
			["key"] = translationKey,
			["name"] = name,
			["descriptionKey"] = descriptionKey,
			["description"] = description,
			["animals"] = animals,
			["value"] = valueModifier,
			["transmission"] = transmission,
			["immunity"] = immunity,
			["prerequisites"] = prerequisites,
			["probability"] = probability,
			["fatality"] = fatality,
			["output"] = output,
			["treatment"] = treatment,
			["recovery"] = recovery,
			["weightGain"] = weightGain,
			["fertilityModifier"] = fertilityModifier,
			["season"] = season
		}

		if xmlFile:hasProperty(key .. ".carrier") then

			local carrier = {}

			if xmlFile:hasProperty(key .. ".carrier.output") then

				local carrierOutput = {}

				xmlFile:iterate(key .. ".output.fillType", function(_, outputKey)

					carrierOutput[xmlFile:getString(outputKey .. "#type")] = xmlFile:getFloat(outputKey .. "#modifier")

				end)

				carrier.output = carrierOutput

			end

			disease.carrier = carrier

		end

		if xmlFile:hasProperty(key .. ".genetic") then

			disease.genetic = {
				["recessive"] = xmlFile:getBool(key .. ".genetic#recessive", false),
				["dominant"] = xmlFile:getBool(key .. ".genetic#dominant", false),
				["saleChance"] = xmlFile:getFloat(key .. ".genetic#saleChance", 0)
			}

		end

		table.insert(self.diseases, disease)

	end)

	xmlFile:delete()

end

function DiseaseManager:getDiseaseByTitle(title)

	for _, disease in pairs(self.diseases) do
		if disease.title == title then
			return disease
		end
	end

	return nil

end

function DiseaseManager:onDayChanged(animal)

	if not self.diseasesEnabled then
		return
	end

	for _, disease in pairs(self.diseases) do

		if not disease.animals[animal.animalTypeIndex] then
			continue
		end

		local eligible = true

		for _, existingDisease in pairs(animal.diseases) do

			if existingDisease.type.title == disease.title then
				eligible = false
				break
			end

		end

		if not eligible then
			continue
		end

		for _, prerequisite in pairs(disease.prerequisites) do

			local currentValue = animal

			for _, path in pairs(prerequisite.path) do

				currentValue = currentValue[path]

				if currentValue == nil then eligible = false break end

			end

			if currentValue ~= prerequisite.value then
				eligible = false
				break
			end

		end

		if not eligible then
			continue
		end

		local probability = 0

		for i = 1, #disease.probability do

			if animal.age <= disease.probability[i].age or i == #disease.probability then
				probability = disease.probability[i].value
				break
			end

		end

		-- Health genetics modifier: better health = lower disease probability
		-- health=1.75 (best) → 0.25x probability
		-- health=1.0 (average) → 1.0x probability
		-- health=0.25 (worst) → 1.75x probability
		local healthModifier = 2.0 - (animal.genetics.health or 1.0)

		-- Season modifier: diseases more likely in certain seasons
		local seasonModifier = self:getCurrentSeasonModifier(disease)

		-- Overcrowding modifier: more animals = higher disease rates
		local overcrowdingModifier = 1.0
		if animal.clusterSystem ~= nil and animal.clusterSystem.owner ~= nil then
			local spec = animal.clusterSystem.owner.spec_husbandryAnimals
			if spec ~= nil and spec.maxNumAnimals ~= nil and spec.maxNumAnimals > 0 then
				local ratio = #animal.clusterSystem.animals / spec.maxNumAnimals
				if ratio > 1.0 then
					overcrowdingModifier = 2.0
				elseif ratio > 0.8 then
					overcrowdingModifier = 1.3
				elseif ratio < 0.5 then
					overcrowdingModifier = 0.8
				end
			end
		end

		if math.random() >= probability * self.diseasesChance * healthModifier * seasonModifier * overcrowdingModifier then
			continue
		end

		animal:addDisease(disease)

	end

end

function DiseaseManager:getCurrentSeasonModifier(disease)

	if disease.season == nil then
		return 1.0
	end

	local month = g_currentMission.environment.currentPeriod + 2
	if month > 12 then
		month = month - 12
	end

	-- Spring: Mar-May (3-5), Summer: Jun-Aug (6-8), Autumn: Sep-Nov (9-11), Winter: Dec-Feb (12,1,2)
	if month >= 3 and month <= 5 then
		return disease.season.spring
	elseif month >= 6 and month <= 8 then
		return disease.season.summer
	elseif month >= 9 and month <= 11 then
		return disease.season.autumn
	else
		return disease.season.winter
	end

end

function DiseaseManager:setGeneticDiseasesForSaleAnimal(animal)

	for _, disease in pairs(self.diseases) do

		if not disease.animals[animal.animalTypeIndex] or disease.genetic == nil or disease.probability[1].value ~= 0 or #disease.probability > 1 then
			continue
		end

		local eligible = true

		for _, existingDisease in pairs(animal.diseases) do

			if existingDisease.type.title == disease.title then
				eligible = false
				break
			end

		end

		if not eligible then
			continue
		end

		if math.random() < disease.genetic.saleChance then

			local numGenes = 1

			if math.random() <= 0.25 then
				numGenes = 2
			end

			animal:addDisease(disease, disease.genetic.recessive and numGenes == 1, numGenes)

		end

	end

end

function DiseaseManager:calculateTransmission(animals, husbandrySpec)

	if not self.diseasesEnabled then
		return
	end

	-- Calculate overcrowding modifier for transmission
	local overcrowdingModifier = 1.0
	if husbandrySpec ~= nil and husbandrySpec.maxNumAnimals ~= nil and husbandrySpec.maxNumAnimals > 0 then
		local ratio = #animals / husbandrySpec.maxNumAnimals
		if ratio > 1.0 then
			overcrowdingModifier = 2.0
		elseif ratio > 0.8 then
			overcrowdingModifier = 1.3
		elseif ratio < 0.5 then
			overcrowdingModifier = 0.8
		end
	end

	local diseases = {}
	local hasDiseases = false

	for _, animal in pairs(animals) do

		for _, disease in pairs(animal.diseases) do

			local type = disease.type

			if type.transmission == nil or type.transmission <= 0 then
				continue
			end

			if diseases[type.title] == nil then
				diseases[type.title] = { ["type"] = type, ["amount"] = 0 }
				hasDiseases = true
			end

			diseases[type.title].amount = diseases[type.title].amount + 1

		end

	end

	if not hasDiseases then
		return
	end

	-- Calculate immune counts per disease for herd immunity
	local immuneCounts = {}
	for _, animal in pairs(animals) do
		for _, disease in pairs(animal.diseases) do
			if disease.cured then  -- cured = immune
				immuneCounts[disease.type.title] = (immuneCounts[disease.type.title] or 0) + 1
			end
		end
	end

	for _, animal in pairs(animals) do

		for title, disease in pairs(diseases) do

			local eligible = true

			for _, existingDisease in pairs(animal.diseases) do

				if existingDisease.type.title == title then
					eligible = false
					break
				end

			end

			if not eligible then
				continue
			end

			for _, prerequisite in pairs(disease.type.prerequisites) do

				local currentValue = animal

				for _, path in pairs(prerequisite.path) do

					currentValue = currentValue[path]

					if currentValue == nil then eligible = false break end

				end

				if currentValue ~= prerequisite.value then
					eligible = false
					break
				end

			end

			if not eligible then
				continue
			end

			-- Health genetics modifier for transmission susceptibility
			local healthModifier = 2.0 - (animal.genetics.health or 1.0)

			-- Herd immunity: if >70% of susceptible animals are immune, transmission is greatly reduced
			local immuneCount = immuneCounts[title] or 0
			local herdImmunityFactor = 1.0
			if (#animals - disease.amount) > 0 then
				local immuneRatio = immuneCount / (#animals - disease.amount)
				if immuneRatio > 0.7 then
					herdImmunityFactor = 0.1  -- herd immunity kicks in
				end
			end

			if math.random() <= disease.type.transmission * (disease.amount / #animals) * healthModifier * overcrowdingModifier * herdImmunityFactor then
				animal:addDisease(disease.type)
			end

		end

	end


end

function DiseaseManager.onSettingChanged(name, state)

	if g_diseaseManager ~= nil then
		g_diseaseManager[name] = state
	end

end