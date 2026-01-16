EL_FSCareerMissionInfo = {}

function EL_FSCareerMissionInfo:saveToXMLFile()
    if self.xmlFile ~= nil and g_currentMission ~= nil and g_currentMission.animalSystem ~= nil then
        g_currentMission.animalSystem:saveToXMLFile(self.savegameDirectory .. "/animalSystem.xml")
        ELSettings.saveToXMLFile()
    end
end

FSCareerMissionInfo.saveToXMLFile = Utils.appendedFunction(FSCareerMissionInfo.saveToXMLFile, EL_FSCareerMissionInfo.saveToXMLFile)