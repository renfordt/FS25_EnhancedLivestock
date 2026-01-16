EL_FarmManager = {}


function EL_FarmManager:loadFromXMLFile(superFunc, path)

	local returnValue = superFunc(self, path)

    local animalSystem = g_currentMission.animalSystem
    animalSystem:initialiseCountries()

    if g_currentMission:getIsServer() then
        local hasData = animalSystem:loadFromXMLFile()
        animalSystem:validateFarms(hasData)
    end

    return returnValue

end

FarmManager.loadFromXMLFile = Utils.overwrittenFunction(FarmManager.loadFromXMLFile, EL_FarmManager.loadFromXMLFile)