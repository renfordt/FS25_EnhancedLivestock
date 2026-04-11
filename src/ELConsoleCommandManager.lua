ELConsoleCommandManager = {}

local elConsoleCommandManager_mt = Class(ELConsoleCommandManager)

function ELConsoleCommandManager.new()

	local self = setmetatable({}, elConsoleCommandManager_mt)

	self.husbandrySystem = g_currentMission.husbandrySystem
	self.animalSystem = g_currentMission.animalSystem
	self.animal = nil
	self.placeable = nil

	if g_currentMission:getIsServer() and not g_currentMission.missionDynamicInfo.isMultiplayer then
		addConsoleCommand("elSetTargetAnimal", "Set the target animal for future console commands", "setAnimal", self, "[type] [farmId] [uniqueId]")
		addConsoleCommand("elSetAnimalGenetics", "Set the genetics of the targeted animal", "setGenetics", self, "[geneticType] [value]")
		addConsoleCommand("elSetAnimalInput", "Set the input of the targeted animal", "setInput", self, "[inputType] [value]")
		addConsoleCommand("elSetAnimalOutput", "Set the output of the targeted animal", "setOutput", self, "[outputType] [value]")
		addConsoleCommand("elAddAnimalDisease", "Add a disease to the targeted animal", "addDisease", self, "[diseaseTitle]")
		addConsoleCommand("elGetNutritionScore", "Get the nutrition score and life stage of the targeted animal", "getNutritionScore", self)
		addConsoleCommand("elGetLifeStage", "Get the life stage and daily requirements of the targeted animal", "getLifeStage", self)
	--addConsoleCommand("elExtractAnimalHierarchy", "Extract visual animal hierarchy to XML file", "extractHierarchy", self, "[subTypeName] [age]")
	--addConsoleCommand("elDumpAnimalPaths", "Dump all animal asset paths (i3d, shapes, config) to console", "dumpAnimalPaths", self)
	end

	return self

end

function ELConsoleCommandManager:setAnimal(animalType, farmId, uniqueId)

	self.animal = nil
	self.placeable = nil

	if animalType == nil or type(animalType) ~= "string" then

		print("elSetTargetAnimal: no animal type given, accepted types:")

		for name, index in pairs(AnimalType) do
			print("|--- " .. name)
		end

		return

	end

	if farmId == nil then
		return "elSetTargetAnimal: no farmId given"
	end

	if uniqueId == nil then
		return "elSetTargetAnimal: no uniqueId given"
	end

	local animalTypeIndex = AnimalType[animalType:upper()]

	for _, placeable in pairs(self.husbandrySystem.placeables) do

		if placeable:getAnimalTypeIndex() ~= animalTypeIndex then
			continue
		end

		local animals = placeable:getClusters()

		for _, animal in pairs(animals) do

			if animal.farmId == farmId and animal.uniqueId == uniqueId then

				self.animal = animal
				self.placeable = placeable

				return "elSetTargetAnimal: animal set successfully"

			end

		end

	end

	for _, trailer in pairs(self.husbandrySystem.livestockTrailers) do

		local trailerType = trailer:getCurrentAnimalType()

		if trailerType == nil or trailerType.typeIndex ~= animalTypeIndex then
			continue
		end

		local animals = trailer:getClusters()

		for _, animal in pairs(animals) do

			if animal.farmId == farmId and animal.uniqueId == uniqueId then

				self.animal = animal

				return "elSetTargetAnimal: animal set successfully"

			end

		end

	end

	return "elSetTargetAnimal: animal not found"

end

function ELConsoleCommandManager:setGenetics(geneticType, value)

	if self.animal == nil then
		return "elSetAnimalGenetics: no targeted animal"
	end

	if geneticType == nil or type(geneticType) ~= "string" or self.animal.genetics[geneticType] == nil then

		print("elSetAnimalGenetics: invalid genetic type given, accepted types:")

		for key, _ in pairs(self.animal.genetics) do
			print("|--- " .. key)
		end

		return

	end

	if value == nil then
		return "elSetAnimalGenetics: no value given"
	end

	value = tonumber(value)

	if value == nil then
		return "elSetAnimalGenetics: invalid value given"
	end

	if value < 0.25 or value > 1.75 then
		return "elSetAnimalGenetics: invalid value given, must be in range 0.25 - 1.75"
	end

	self.animal.genetics[geneticType] = value

	return "elSetAnimalGenetics: animal genetics set successfully"

end

function ELConsoleCommandManager:setInput(inputType, value)

	if self.animal == nil then
		return "elSetAnimalInput: no targeted animal"
	end

	if inputType == nil or type(inputType) ~= "string" or self.animal.input[inputType] == nil then

		print("elSetAnimalInput: invalid input type given, accepted types:")

		for key, _ in pairs(self.animal.input) do
			print("|--- " .. key)
		end

		return

	end

	if value == nil then
		return "elSetAnimalInput: no value given"
	end

	value = tonumber(value)

	if value == nil then
		return "elSetAnimalInput: invalid value given"
	end

	if value < 0 then
		return "elSetAnimalInput: invalid value given, must be higher than or equal to 0"
	end

	self.animal.input[inputType] = value
	if self.placeable ~= nil then
		self.placeable:updateInputAndOutput(self.placeable:getClusters())
	end

	return "elSetAnimalInput: animal input set successfully"

end

function ELConsoleCommandManager:setOutput(outputType, value)

	if self.animal == nil then
		return "elSetAnimalOutput: no targeted animal"
	end

	if outputType == nil or type(outputType) ~= "string" or self.animal.output[outputType] == nil then

		print("elSetAnimalOutput: invalid output type given, accepted types:")

		for key, _ in pairs(self.animal.output) do
			print("|--- " .. key)
		end

		return

	end

	if value == nil then
		return "elSetAnimalOutput: no value given"
	end

	value = tonumber(value)

	if value == nil then
		return "elSetAnimalOutput: invalid value given"
	end

	if value < 0 then
		return "elSetAnimalOutput: invalid value given, must be higher than or equal to 0"
	end

	self.animal.output[outputType] = value
	if self.placeable ~= nil then
		self.placeable:updateInputAndOutput(self.placeable:getClusters())
	end

	return "elSetAnimalOutput: animal output set successfully"

end

function ELConsoleCommandManager:addDisease(diseaseTitle)

	if self.animal == nil then
		return "elAddAnimalDisease: no targeted animal"
	end

	if g_diseaseManager == nil then
		return "elAddAnimalDisease: disease manager not available"
	end

	if diseaseTitle == nil or type(diseaseTitle) ~= "string" then

		print("elAddAnimalDisease: no disease title given, accepted diseases for this animal type:")

		for _, disease in pairs(g_diseaseManager.diseases) do
			if disease.animals[self.animal.animalTypeIndex] then
				print("|--- " .. disease.title)
			end
		end

		return

	end

	local disease = g_diseaseManager:getDiseaseByTitle(diseaseTitle)

	if disease == nil then

		print("elAddAnimalDisease: disease not found, accepted diseases:")

		for _, d in pairs(g_diseaseManager.diseases) do
			print("|--- " .. d.title)
		end

		return

	end

	if not disease.animals[self.animal.animalTypeIndex] then

		print("elAddAnimalDisease: disease not applicable to this animal type, accepted diseases:")

		for _, d in pairs(g_diseaseManager.diseases) do
			if d.animals[self.animal.animalTypeIndex] then
				print("|--- " .. d.title)
			end
		end

		return

	end

	for _, existingDisease in pairs(self.animal.diseases) do
		if existingDisease.type.title == diseaseTitle then
			return "elAddAnimalDisease: animal already has this disease"
		end
	end

	self.animal:addDisease(disease)

	return "elAddAnimalDisease: disease added successfully"

end

function ELConsoleCommandManager:getNutritionScore()

	if self.animal == nil then
		return "elGetNutritionScore: no targeted animal"
	end

	if g_nutritionManager == nil then
		return "elGetNutritionScore: nutrition manager not available"
	end

	local animal = self.animal
	local stage = g_nutritionManager:getLifeStage(animal)
	local stageName = stage ~= nil and stage.name or "UNKNOWN"

	print(string.format("  Life Stage: %s", stageName))
	print(string.format("  Weight: %.1f kg", animal.weight or 0))
	print(string.format("  Body Condition: %.3f", animal.bodyCondition or 0.5))
	print(string.format("  Nutrition Score: %s", animal.nutritionScore ~= nil and string.format("%.3f", animal.nutritionScore) or "not computed yet"))

	local requirements = g_nutritionManager:getDailyRequirements(animal)

	if requirements ~= nil then
		print(string.format("  Daily DMI: %.2f kg", requirements.dmiKg))
		print(string.format("  Daily Energy: %.1f MJ", requirements.energyMJ))
		print(string.format("  Daily Protein: %.1f g", requirements.proteinG))
	end

	if self.placeable ~= nil then

		local composition = g_nutritionManager:getTroughComposition(self.placeable)

		if composition ~= nil then
			print(string.format("  Trough DM: %.1f kg", composition.totalDMKg))
			print(string.format("  Trough Avg Energy: %.1f MJ/kg DM", composition.avgEnergy))
			print(string.format("  Trough Avg Protein: %.1f g/kg DM", composition.avgProtein))
		end

	end

	if animal.isPregnant then
		local trimester = g_nutritionManager:getPregnancyTrimester(animal)
		print(string.format("  Pregnancy Trimester: %s", trimester ~= nil and tostring(trimester) or "N/A"))
	end

	return "elGetNutritionScore: done"

end

function ELConsoleCommandManager:getLifeStage()

	if self.animal == nil then
		return "elGetLifeStage: no targeted animal"
	end

	if g_nutritionManager == nil then
		return "elGetLifeStage: nutrition manager not available"
	end

	local animal = self.animal
	local stage = g_nutritionManager:getLifeStage(animal)

	if stage == nil then
		return "elGetLifeStage: could not determine life stage (unknown species?)"
	end

	print(string.format("  Stage: %s", stage.name))
	print(string.format("  DMI %%BW: %.1f%%", stage.dmiPercent))
	print(string.format("  Energy/kgBW075: %.2f MJ", stage.energyPerKgBW075))
	print(string.format("  Protein/kgBW075: %.1f g", stage.proteinPerKgBW075))
	print(string.format("  Age Range: %d - %d months", stage.minAge, stage.maxAge))
	print(string.format("  Gender: %s", stage.gender))
	print(string.format("  Condition: %s", stage.condition))

	local hourlyFood = g_nutritionManager:getHourlyConsumptionLiters(animal)

	if hourlyFood ~= nil then
		print(string.format("  Hourly Food Consumption: %.2f liters/hour", hourlyFood))
	end

	local hourlyWater = g_nutritionManager:getHourlyWaterConsumptionLiters(animal)

	if hourlyWater ~= nil then
		print(string.format("  Hourly Water Consumption: %.2f liters/hour", hourlyWater))
	end

	local maxADG = g_nutritionManager:getMaxADG(animal)

	if maxADG ~= nil then
		print(string.format("  Max ADG: %.3f kg/day", maxADG))
	end

	return "elGetLifeStage: done"

end

--function ELConsoleCommandManager:extractHierarchy(subTypeName, age)
--
--	return VisualAnimal.extractHierarchyToXml(subTypeName, age)
--
--end

--function ELConsoleCommandManager:dumpAnimalPaths()
--
--	return VisualAnimal.dumpAnimalPaths()
--
--end