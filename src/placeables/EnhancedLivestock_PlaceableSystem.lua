EnhancedLivestock_PlaceableSystem = {}

local modSettingsDirectory = g_currentModSettingsDirectory

function EnhancedLivestock_PlaceableSystem:saveToXML(_, _)

	createFolder(modSettingsDirectory)
	local xmlFile = XMLFile.loadIfExists("EnhancedLivestock", modSettingsDirectory .. "Settings.xml")

	if xmlFile == nil then
		xmlFile = XMLFile.create("EnhancedLivestock", modSettingsDirectory .. "Settings.xml", "Settings")
	end

	if xmlFile ~= nil then

		xmlFile:setInt("Settings.setting(0)#maxHusbandries", EnhancedLivestock_AnimalClusterHusbandry.MAX_HUSBANDRIES)
		xmlFile:save(false, true)
		xmlFile:delete()

	end

end

PlaceableSystem.saveToXML = Utils.prependedFunction(PlaceableSystem.saveToXML, EnhancedLivestock_PlaceableSystem.saveToXML)