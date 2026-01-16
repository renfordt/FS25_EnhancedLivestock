ELHandTools = {}


local modDirectory = g_currentModDirectory
local modName = g_currentModName
local path = modDirectory .. "xml/handTools.xml"
local xmlFile = XMLFile.loadIfExists("elHandTools", path)

ELHandTools.xmlPaths = {}

if xmlFile ~= nil then

	xmlFile:iterate("handTools.specializations.specialization", function(_, key)

		local name = xmlFile:getString(key .. "#name")
		local className = xmlFile:getString(key .. "#className")
		local filename = xmlFile:getString(key .. "#filename")

		g_handToolSpecializationManager:addSpecialization(name, className, modDirectory .. filename)

	end)

	xmlFile:iterate("handTools.types.type", function(_, key)

		g_handToolTypeManager:loadTypeFromXML(xmlFile.handle, key, false, nil, modName)

		ELHandTools.xmlPaths[xmlFile:getString(key .. "#name")] = modDirectory .. xmlFile:getString(key .. "#xmlFile")

	end)

end