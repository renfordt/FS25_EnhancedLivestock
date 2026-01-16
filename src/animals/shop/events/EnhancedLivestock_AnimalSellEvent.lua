EnhancedLivestock_AnimalSellEvent = {}

function EnhancedLivestock_AnimalSellEvent:run(connection)
    if connection:getIsServer() then return end

    if g_currentMission:getHasPlayerPermission("tradeAnimals", connection) then

        local validate = AnimalSellEvent.validate(self.object, self.clusterId, self.numAnimals, self.sellPrice, self.feePrice)
        if validate == nil then
            
            local animal = self.object:getClusterById(self.clusterId)
            animal.isSold = true
            local spec = self.object.spec_husbandryAnimals

            if animal.idFull ~= nil and animal.idFull ~= "1-1" and spec ~= nil then

                local sep = string.find(animal.idFull, "-")
                local husbandry = tonumber(string.sub(animal.idFull, 1, sep - 1))
                local animalId = tonumber(string.sub(animal.idFull, sep + 1))

                if husbandry == 0 or animalId == 0 then return end

                removeHusbandryAnimal(husbandry, animalId)

                local clusterHusbandry = spec.clusterHusbandry
                clusterHusbandry.husbandryIdsToVisualAnimalCount[husbandry] = math.max(clusterHusbandry.husbandryIdsToVisualAnimalCount[husbandry] - 1, 0)
                clusterHusbandry.visualAnimalCount = math.max(clusterHusbandry.visualAnimalCount - 1, 0)

                for husbandryIndex, animalIds in pairs(clusterHusbandry.animalIdToCluster) do

                    if clusterHusbandry.husbandryIds[husbandryIndex] == husbandry then

                        table.remove(animalIds, animalId)
                        break

                    end

                end

            end

        end
    end
end

AnimalSellEvent.run = Utils.prependedFunction(AnimalSellEvent.run, EnhancedLivestock_AnimalSellEvent.run)