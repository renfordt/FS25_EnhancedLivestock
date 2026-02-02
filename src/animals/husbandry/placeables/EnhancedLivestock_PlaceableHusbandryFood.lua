EnhancedLivestock_PlaceableHusbandryFood = {}

function EnhancedLivestock_PlaceableHusbandryFood.registerOverwrittenFunctions(placeable)
    SpecializationUtil.registerOverwrittenFunction(placeable, "updateInputAndOutput", PlaceableHusbandryFood.updateInputAndOutput)
end

PlaceableHusbandryFood.registerOverwrittenFunctions = Utils.appendedFunction(PlaceableHusbandryFood.registerOverwrittenFunctions, EnhancedLivestock_PlaceableHusbandryFood.registerOverwrittenFunctions)

function EnhancedLivestock_PlaceableHusbandryFood:onHusbandryAnimalsUpdate(superFunc, animals)
end

PlaceableHusbandryFood.onHusbandryAnimalsUpdate = Utils.overwrittenFunction(PlaceableHusbandryFood.onHusbandryAnimalsUpdate, EnhancedLivestock_PlaceableHusbandryFood.onHusbandryAnimalsUpdate)

function EnhancedLivestock_PlaceableHusbandryFood.onSettingChanged(name, state)

    EnhancedLivestock_PlaceableHusbandryFood[name] = state

end

function PlaceableHusbandryFood:updateInputAndOutput(superFunc, animals)

    superFunc(self, animals)

    local spec = self.spec_husbandryFood
    spec.litersPerHour = 0

    for _, animal in pairs(animals) do

        local subType = animal:getSubType()

        if subType ~= nil then

            local food = subType.input.food

            if food ~= nil then

                spec.litersPerHour = spec.litersPerHour + animal:getInput("food")

            end

        end

    end

end