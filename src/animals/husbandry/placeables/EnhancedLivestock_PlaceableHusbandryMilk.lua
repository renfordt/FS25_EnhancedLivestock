EnhancedLivestock_PlaceableHusbandryMilk = {}

function EnhancedLivestock_PlaceableHusbandryMilk.registerOverwrittenFunctions(placeable)
	SpecializationUtil.registerOverwrittenFunction(placeable, "updateInputAndOutput", PlaceableHusbandryMilk.updateInputAndOutput)
end

PlaceableHusbandryMilk.registerOverwrittenFunctions = Utils.appendedFunction(PlaceableHusbandryMilk.registerOverwrittenFunctions, EnhancedLivestock_PlaceableHusbandryMilk.registerOverwrittenFunctions)

function EnhancedLivestock_PlaceableHusbandryMilk:onHusbandryAnimalsUpdate(_, _)
end

PlaceableHusbandryMilk.onHusbandryAnimalsUpdate = Utils.overwrittenFunction(PlaceableHusbandryMilk.onHusbandryAnimalsUpdate, EnhancedLivestock_PlaceableHusbandryMilk.onHusbandryAnimalsUpdate)

function PlaceableHusbandryMilk:updateInputAndOutput(superFunc, animals)

	superFunc(self, animals)

	local spec = self.spec_husbandryMilk

	for fillType, _ in pairs(spec.litersPerHour) do
		spec.litersPerHour[fillType] = 0
	end

	spec.activeFillTypes = {}
	spec.hasMilkProduction = false

	for _, animal in pairs(animals) do

		local subType = animal:getSubType()

		if subType ~= nil then

			local milk = subType.output.milk

			if milk ~= nil then

				spec.litersPerHour[milk.fillType] = (spec.litersPerHour[milk.fillType] or 0) + animal:getOutput("milk")

				table.addElement(spec.activeFillTypes, milk.fillType)
				spec.hasMilkProduction = true

			end

		end

	end

end