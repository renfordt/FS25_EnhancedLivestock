EL_PlaceableHusbandry = {}

function EL_PlaceableHusbandry.registerFunctions(placeable)
	SpecializationUtil.registerFunction(placeable, "updateInputAndOutput", PlaceableHusbandry.updateInputAndOutput)
end

PlaceableHusbandry.registerFunctions = Utils.appendedFunction(PlaceableHusbandry.registerFunctions, EL_PlaceableHusbandry.registerFunctions)

function EL_PlaceableHusbandry:onHourChanged()

	if g_nutritionManager ~= nil then
		g_nutritionManager:clearTroughCache()
	end

	local animals = self.spec_husbandryAnimals:getClusters()
	local temp = g_currentMission.environment.weather.temperatureUpdater.currentMin or 20

	for _, animal in pairs(animals) do
		animal:updateInput()
		animal:updateOutput(temp)
	end

	if self.isServer then
		self:updateInputAndOutput(animals)
	end

end

PlaceableHusbandry.onHourChanged = Utils.appendedFunction(PlaceableHusbandry.onHourChanged, EL_PlaceableHusbandry.onHourChanged)

function PlaceableHusbandry:updateInputAndOutput(animals)
end