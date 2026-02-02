ELSettings = {}
local modDirectory = g_currentModDirectory
local modName = g_currentModName
local modSettingsDirectory = g_currentModSettingsDirectory

local modDirectoryPath = string.split(modDirectory, "/")
local baseDirectory = ""

for i = 1, #modDirectoryPath - 2 do

    baseDirectory = baseDirectory .. (i == 1 and "" or "/") .. modDirectoryPath[i]

end

g_gui:loadProfiles(modDirectory .. "gui/guiProfiles.xml")

function ELSettings.onClickTagColour()

    EarTagColourPickerDialog.show()

end

function ELSettings.onClickExportCSV()

    local file = io.open(modSettingsDirectory .. "animals.csv", "w")

    file:write("Type,Subtype,Country,Farm Id,Unique Id,Age,Health,Weight,Value,Value / kg,Pregnant,Expected Offspring,Lactating,Food,Water,Straw,Product,Manure,Liquid Manure")

    local husbandrySystem = g_currentMission.husbandrySystem
    local animalSystem = g_currentMission.animalSystem

    for _, placeable in pairs(husbandrySystem.placeables) do

        local animals = placeable:getClusters()

        for _, animal in pairs(animals) do

            local hasMonitor = animal.monitor.active or animal.monitor.removed

            local foodInput = animal:getInput("food") * 24
            local waterInput = animal:getInput("water") * 24
            local strawInput = animal:getInput("straw") * 24
            local manureOutput = animal:getOutput("manure") * 24
            local liquidManureOutput = animal:getOutput("liquidManure") * 24
            local milkOutput = animal:getOutput("milk") * 24
            local palletsOutput = animal:getOutput("pallets") * 24

            local productOutput = milkOutput > palletsOutput and milkOutput or palletsOutput

            local value = animal:getSellPrice()
            local valuePerKg = hasMonitor and (value / animal.weight) or "no monitor"

            local expectedOffspring = animal.pregnancy ~= nil and animal.pregnancy.pregnancies ~= nil and #animal.pregnancy.pregnancies or 0

            file:write(string.format("\n%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s", animalSystem.types[animal.animalTypeIndex].name, animal.subType, EnhancedLivestock.AREA_CODES[animal.birthday.country].code, animal.farmId, animal.uniqueId, animal.age, hasMonitor and animal.health or "no monitor", hasMonitor and animal.weight or "no monitor", value, valuePerKg, animal.isPregnant and "yes" or "no", expectedOffspring, (hasMonitor and (animal.isLactating and "yes" or "no") or "no monitor"), hasMonitor and foodInput or "no monitor", hasMonitor and waterInput or "no monitor", hasMonitor and strawInput or "no monitor", hasMonitor and productOutput or "no monitor", hasMonitor and manureOutput or "no monitor", hasMonitor and liquidManureOutput or "no monitor"))

        end

    end

    file:close()

    InfoDialog.show(modSettingsDirectory .. "animals.csv")

end

local function getFilesRecursively(path, parent)

    local files = Files.new(path).files

    for _, file in pairs(files) do

        if file.isDirectory then

            table.insert(parent.folders, { ["folders"] = {}, ["files"] = {}, ["name"] = file.filename, ["path"] = file.path })
            getFilesRecursively(file.path, parent.folders[#parent.folders])
            continue

        end

        local name = file.filename

        if #name >= 4 and string.sub(name, #name - 3) == ".xml" then
            table.insert(parent.files, { ["name"] = name, ["valid"] = true })
        end

    end

end

function ELSettings.onClickChangeAnimalsXML()

    local files = { { ["folders"] = {}, ["files"] = {}, ["name"] = baseDirectory, ["path"] = baseDirectory } }

    getFilesRecursively(baseDirectory, files[1])

    FileExplorerDialog.show(files, baseDirectory, ELSettings.onFileExplorerCallback)

end

function ELSettings.onFileExplorerCallback(path)

    ELSettings.animalsXMLPath = path

end

ELSettings.SETTINGS = {

    ["deathEnabled"] = {
        ["index"] = 1,
        ["type"] = "BinaryOption",
        ["dynamicTooltip"] = true,
        ["default"] = 2,
        ["binaryType"] = "offOn",
        ["values"] = { false, true },
        ["callback"] = Animal.onSettingChanged
    },

    ["accidentsChance"] = {
        ["index"] = 2,
        ["type"] = "MultiTextOption",
        ["default"] = 11,
        ["valueType"] = "float",
        ["values"] = { 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0 },
        ["callback"] = Animal.onSettingChanged,
        ["dependancy"] = {
            ["name"] = "deathEnabled",
            ["state"] = 2
        }
    },

    ["foodScale"] = {
        ["index"] = 3,
        ["type"] = "MultiTextOption",
        ["default"] = 2,
        ["valueType"] = "float",
        ["values"] = { 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5 },
        ["callback"] = EnhancedLivestock_PlaceableHusbandryFood.onSettingChanged
    },

    ["maxDealerAnimals"] = {
        ["index"] = 4,
        ["type"] = "MultiTextOption",
        ["default"] = 4,
        ["valueType"] = "int",
        ["values"] = { 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 },
        ["callback"] = AnimalSystem.onSettingChanged
    },

    ["resetDealer"] = {
        ["index"] = 5,
        ["type"] = "Button",
        ["ignore"] = true,
        ["callback"] = AnimalSystem.onClickResetDealer
    },

    ["tagColour"] = {
        ["index"] = 6,
        ["type"] = "Button",
        ["ignore"] = true,
        ["callback"] = ELSettings.onClickTagColour
    },

    ["exportCSV"] = {
        ["index"] = 7,
        ["type"] = "Button",
        ["ignore"] = true,
        ["callback"] = ELSettings.onClickExportCSV
    },

    ["maxNumMessages"] = {
        ["index"] = 7,
        ["type"] = "MultiTextOption",
        ["default"] = 5,
        ["valueType"] = "int",
        ["values"] = { 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3500, 4000, 4500, 5000 },
        ["callback"] = EnhancedLivestock_PlaceableHusbandryAnimals.onSettingChanged
    },

    ["diseasesEnabled"] = {
        ["index"] = 8,
        ["type"] = "BinaryOption",
        ["dynamicTooltip"] = true,
        ["default"] = 2,
        ["binaryType"] = "offOn",
        ["values"] = { false, true },
        ["callback"] = DiseaseManager.onSettingChanged
    },

    ["diseasesChance"] = {
        ["index"] = 9,
        ["type"] = "MultiTextOption",
        ["default"] = 4,
        ["valueType"] = "float",
        ["values"] = { 0.25, 0.5, 0.75, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5 },
        ["callback"] = DiseaseManager.onSettingChanged,
        ["dependancy"] = {
            ["name"] = "diseasesEnabled",
            ["state"] = 2
        }
    },

    ["useCustomAnimals"] = {
        ["index"] = 10,
        ["type"] = "BinaryOption",
        ["dynamicTooltip"] = true,
        ["default"] = 1,
        ["binaryType"] = "offOn",
        ["values"] = { false, true },
        ["callback"] = ELSettings.onSettingChanged
    },

    ["animalsXML"] = {
        ["index"] = 10,
        ["type"] = "Button",
        ["ignore"] = true,
        ["callback"] = ELSettings.onClickChangeAnimalsXML,
        ["dependancy"] = {
            ["name"] = "useCustomAnimals",
            ["state"] = 2
        }
    },

    ["earTagTextEnabled"] = {
        ["index"] = 11,
        ["type"] = "BinaryOption",
        ["default"] = 2,
        ["binaryType"] = "offOn",
        ["values"] = { false, true },
        ["callback"] = VisualAnimal.onSettingChanged
    }

}

ELSettings.BinaryOption = nil
ELSettings.MultiTextOption = nil
ELSettings.Button = nil

function ELSettings.loadFromXMLFile()

    if g_currentMission.missionInfo == nil or g_currentMission.missionInfo.savegameDirectory == nil then
        return
    end

    local path = g_currentMission.missionInfo.savegameDirectory .. "/elSettings.xml"

    local xmlFile = XMLFile.loadIfExists("elSettings", path)

    if xmlFile ~= nil then

        local key = "settings"

        for name, setting in pairs(ELSettings.SETTINGS) do

            if setting.ignore then
                continue
            end

            setting.state = xmlFile:getInt(key .. "." .. name .. "#value", setting.default)

            if setting.state > #setting.values then
                setting.state = #setting.values
            end

            if name == "useCustomAnimals" and setting.state == 2 then
                ELSettings.animalsXMLPath = xmlFile:getString("settings.useCustomAnimals#path")
            end

        end

        xmlFile:delete()

    end

end

function ELSettings.saveToXMLFile(name, state)

    if ELSettings.isSaving or g_currentMission.missionInfo == nil or g_currentMission.missionInfo.savegameDirectory == nil then
        return
    end

    if g_server ~= nil then

        ELSettings.isSaving = true

        local path = g_currentMission.missionInfo.savegameDirectory .. "/elSettings.xml"
        local xmlFile = XMLFile.create("elSettings", path, "settings")

        if xmlFile ~= nil then

            for settingName, setting in pairs(ELSettings.SETTINGS) do

                if setting.ignore then
                    continue
                end
                xmlFile:setInt("settings." .. settingName .. "#value", setting.state or setting.default)

                if settingName == "useCustomAnimals" and setting.state == 2 and ELSettings.animalsXMLPath ~= nil then
                    xmlFile:setString("settings.useCustomAnimals#path", ELSettings.animalsXMLPath)
                end

            end

            local saved = xmlFile:save(false, true)

            xmlFile:delete()

        end

    end

    ELSettings.isSaving = false

end

function ELSettings.initialize()

    if g_server ~= nil then
        ELSettings.loadFromXMLFile()
    end

    local settingsPage = g_inGameMenu.pageSettings
    local scrollPanel = settingsPage.gameSettingsLayout

    local sectionHeader, binaryOptionElement, multiOptionElement, buttonElement

    for _, element in pairs(scrollPanel.elements) do

        if element.name == "sectionHeader" and sectionHeader == nil then
            sectionHeader = element:clone(scrollPanel)
        end

        if element.typeName == "Bitmap" then

            if element.elements[1].typeName == "BinaryOption" and binaryOptionElement == nil then
                binaryOptionElement = element
            end

            if element.elements[1].typeName == "MultiTextOption" and multiOptionElement == nil then
                multiOptionElement = element
            end

            if element.elements[1].typeName == "Button" and buttonElement == nil then
                buttonElement = element
            end

        end

        if multiOptionElement and binaryOptionElement and sectionHeader and buttonElement then
            break
        end

    end

    if multiOptionElement == nil or binaryOptionElement == nil or sectionHeader == nil or buttonElement == nil then
        return
    end

    ELSettings.BinaryOption = binaryOptionElement
    ELSettings.MultiTextOption = multiOptionElement
    ELSettings.Button = buttonElement

    local prefix = "el_settings_"

    sectionHeader:setText(g_i18n:getText("el_settings"))

    local maxIndex = 0

    for _, setting in pairs(ELSettings.SETTINGS) do
        maxIndex = maxIndex < setting.index and setting.index or maxIndex
    end

    for i = 1, maxIndex do

        for name, setting in pairs(ELSettings.SETTINGS) do

            if setting.index ~= i then
                continue
            end

            setting.state = setting.state or setting.default
            local template = ELSettings[setting.type]:clone(scrollPanel)
            local settingsPrefix = "el_settings_" .. name .. "_"
            template.id = nil

            for _, element in pairs(template.elements) do

                if element.typeName == "Text" then
                    element:setText(g_i18n:getText(settingsPrefix .. "label"))
                    element.id = nil
                end

                if element.typeName == setting.type then

                    if setting.type == "Button" then
                        element:setText(g_i18n:getText(settingsPrefix .. "text"))
                        element:applyProfile("el_settingsButton")
                        element.isAlwaysFocusedOnOpen = false
                        element.focused = false
                    else

                        local texts = {}

                        if setting.binaryType == "offOn" then
                            texts[1] = g_i18n:getText("el_settings_off")
                            texts[2] = g_i18n:getText("el_settings_on")
                        else

                            for i, value in pairs(setting.values) do

                                if setting.valueType == "int" then
                                    texts[i] = tostring(value)
                                elseif setting.valueType == "float" then
                                    texts[i] = string.format("%.0f%%", value * 100)
                                else
                                    texts[i] = g_i18n:getText(settingsPrefix .. "texts_" .. i)
                                end
                            end

                        end

                        element:setTexts(texts)
                        element:setState(setting.state)

                        if setting.dynamicTooltip then
                            element.elements[1]:setText(g_i18n:getText(settingsPrefix .. "tooltip_" .. setting.state))
                        else
                            element.elements[1]:setText(g_i18n:getText(settingsPrefix .. "tooltip"))
                        end

                    end

                    element.id = "els_" .. name
                    element.onClickCallback = ELSettings.onSettingChanged

                    setting.element = element

                    if setting.dependancy then
                        local dependancy = ELSettings.SETTINGS[setting.dependancy.name]
                        if dependancy ~= nil and dependancy.element ~= nil then
                            element:setDisabled(dependancy.state ~= setting.dependancy.state)
                        end
                    end

                end

            end

        end

    end

end

function ELSettings.onSettingChanged(_, state, button)

    if button == nil then
        button = state
    end

    if button == nil or button.id == nil then
        return
    end

    if not string.contains(button.id, "els_") then
        return
    end

    local name = string.sub(button.id, 5)
    local setting = ELSettings.SETTINGS[name]

    if setting == nil then
        return
    end

    if setting.ignore then
        if setting.callback then
            setting.callback()
        end
        return
    end

    if setting.callback then
        setting.callback(name, setting.values[state])
    end

    setting.state = state

    for _, s in pairs(ELSettings.SETTINGS) do
        if s.dependancy and s.dependancy.name == name then
            s.element:setDisabled(s.dependancy.state ~= state)
        end
    end

    if setting.dynamicTooltip and setting.element ~= nil then
        setting.element.elements[1]:setText(g_i18n:getText("el_settings_" .. name .. "_tooltip_" .. setting.state))
    end

    if g_server ~= nil then

        --ELSettings.saveToXMLFile(name, state)

    else

        --EL_BroadcastSettingsEvent.sendEvent(name)

    end

end

function ELSettings.applyDefaultSettings()

    if g_server == nil then

        --EL_BroadcastSettingsEvent.sendEvent()

    else

        for name, setting in pairs(ELSettings.SETTINGS) do

            if setting.ignore then
                continue
            end

            if setting.callback ~= nil then
                setting.callback(name, setting.values[setting.state])
            end

            if setting.dynamicTooltip and setting.element ~= nil then
                setting.element.elements[1]:setText(g_i18n:getText("el_settings_" .. name .. "_tooltip_" .. setting.state))
            end

            for _, s in pairs(ELSettings.SETTINGS) do
                if s.dependancy and s.dependancy.name == name and s.element ~= nil then
                    s.element:setDisabled(s.dependancy.state ~= state)
                end
            end
        end

    end
end

function ELSettings.getAnimalsXMLPath()

    if ELSettings.customAnimals == nil or ELSettings.customAnimals.animals == nil then
        return nil
    end

    return ELSettings.customAnimals.basePath .. ELSettings.customAnimals.animals

end

function ELSettings.getFillTypesXMLPath()

    if ELSettings.customAnimals == nil then
        return nil
    end

    return ELSettings.customAnimals.basePath .. ELSettings.customAnimals.fillTypes

end

function ELSettings.getTranslationsFolderPath()

    if ELSettings.customAnimals == nil then
        return nil
    end

    return ELSettings.customAnimals.basePath .. ELSettings.customAnimals.translations

end

function ELSettings.getAnimalsBasePath()

    if ELSettings.customAnimals == nil then
        return nil
    end

    return ELSettings.customAnimals.basePath

end

function ELSettings.getAnimalFiles()

    if ELSettings.customAnimals == nil then
        return nil
    end

    return ELSettings.customAnimals.animalFiles

end

function ELSettings.getOverrideVanillaAnimals()

    if ELSettings.customAnimals == nil then
        return false
    end

    return ELSettings.customAnimals.override

end

function ELSettings.detectAnimalPackageMod()

    -- Check if FS25_AnimalPackage_vanillaEdition mod is loaded
    if g_modIsLoaded == nil or not g_modIsLoaded["FS25_AnimalPackage_vanillaEdition"] then
        return false
    end

    -- Get the mod directory from Giants Engine (works with zipped mods)
    local animalPackageDir = g_modNameToDirectory["FS25_AnimalPackage_vanillaEdition"]

    if animalPackageDir == nil then
        Logging.warning("[EnhancedLivestock] FS25_AnimalPackage_vanillaEdition is loaded but directory could not be determined")
        return false
    end

    Logging.info("[EnhancedLivestock] Found FS25_AnimalPackage_vanillaEdition at: %s", animalPackageDir)

    -- Check if the fillTypes.xml exists to verify the mod structure
    local fillTypesPath = animalPackageDir .. "xmls/fillTypes.xml"
    local testFile = XMLFile.loadIfExists("testAnimalPackage", fillTypesPath)

    if testFile == nil then
        Logging.warning("[EnhancedLivestock] FS25_AnimalPackage_vanillaEdition detected but could not find expected files at: %s", fillTypesPath)
        return false
    end

    testFile:delete()

    -- The external mod splits animals into individual files
    local animalFiles = {
        "xmls/animals/cow.xml",
        "xmls/animals/pig.xml",
        "xmls/animals/sheep.xml",
        "xmls/animals/horse.xml",
        "xmls/animals/chicken.xml"
    }

    -- Verify which animal files exist
    local foundFiles = {}
    Logging.info("[EnhancedLivestock] Checking for animal files in: %s", animalPackageDir)

    for _, file in ipairs(animalFiles) do
        local fullPath = animalPackageDir .. file
        Logging.info("[EnhancedLivestock] Checking: %s", fullPath)
        local animalTestFile = XMLFile.loadIfExists("testAnimalFile_" .. file, fullPath)
        if animalTestFile ~= nil then
            animalTestFile:delete()
            table.insert(foundFiles, file)
            Logging.info("[EnhancedLivestock] Found animal file: %s", file)
        else
            Logging.info("[EnhancedLivestock] NOT found: %s", file)
        end
    end

    Logging.info("[EnhancedLivestock] Found %d animal files", #foundFiles)

    if #foundFiles == 0 then
        Logging.warning("[EnhancedLivestock] Could not find any animal XML files in FS25_AnimalPackage_vanillaEdition")
        Logging.warning("[EnhancedLivestock] Will use vanilla animals with external mod's fill types only")
        -- Still set up customAnimals but without animalFiles - fillTypes will still be used
        ELSettings.customAnimals = {
            ["basePath"] = nil, -- Don't override basePath when no animal files found
            ["animals"] = nil,
            ["animalFiles"] = nil,
            ["fillTypes"] = "xmls/fillTypes.xml",
            ["translations"] = nil,
            ["override"] = false  -- Don't override vanilla animals
        }
        -- Still load fill types even if animal files not found
        local fillTypesXML = loadXMLFile("animalPackageFillTypes", fillTypesPath)
        if fillTypesXML ~= nil then
            g_fillTypeManager:loadFillTypes(fillTypesXML, animalPackageDir, false, "FS25_AnimalPackage_vanillaEdition")
            Logging.info("[EnhancedLivestock] Successfully loaded fill types from FS25_AnimalPackage_vanillaEdition (fill types only mode)")
        end
        return true  -- Return true so we don't fall back to custom animals configuration
    end

    -- Configure custom animals to use the Animal Package mod with multiple files
    ELSettings.customAnimals = {
        ["basePath"] = animalPackageDir,
        ["animals"] = nil, -- We use animalFiles instead
        ["animalFiles"] = foundFiles, -- List of individual animal XML files
        ["fillTypes"] = "xmls/fillTypes.xml",
        ["translations"] = nil, -- External mod uses vanilla translations
        ["override"] = true  -- Override vanilla animals with Animal Package animals
    }

    Logging.info("[EnhancedLivestock] Configured %d animal files: %s", #foundFiles, table.concat(foundFiles, ", "))

    -- Load fill types from the external mod
    local fillTypesXML = loadXMLFile("animalPackageFillTypes", fillTypesPath)
    if fillTypesXML ~= nil then
        g_fillTypeManager:loadFillTypes(fillTypesXML, animalPackageDir, false, "FS25_AnimalPackage_vanillaEdition")
        Logging.info("[EnhancedLivestock] Successfully loaded fill types from FS25_AnimalPackage_vanillaEdition")
    end

    Logging.info("[EnhancedLivestock] Using animals from FS25_AnimalPackage_vanillaEdition mod")
    return true

end

function ELSettings.validateCustomAnimalsConfiguration()

    -- First check if Animal Package mod should be used
    if ELSettings.detectAnimalPackageMod() then
        return
    end

    if ELSettings.SETTINGS.useCustomAnimals.state == 1 or ELSettings.animalsXMLPath == nil or g_currentMission.missionDynamicInfo.isMultiplayer then
        return
    end

    local xmlFile = XMLFile.loadIfExists("customAnimalsConfig", ELSettings.animalsXMLPath)

    if xmlFile == nil then
        return
    end

    local basePath
    local splitPath = string.split(ELSettings.animalsXMLPath, "/")

    for i = #splitPath, 1, -1 do

        local path = table.concat(splitPath, "/", 1, i)

        if path == baseDirectory then
            basePath = table.concat(splitPath, "/", 1, i + 1) .. "/"
            break
        end

    end

    if basePath == nil then
        return
    end

    ELSettings.customAnimals = {
        ["basePath"] = basePath,
        ["animals"] = xmlFile:getString("EnhancedLivestock#animals", "animals.xml"),
        ["fillTypes"] = xmlFile:getString("EnhancedLivestock#fillTypes", "fillTypes.xml"),
        ["translations"] = xmlFile:getString("EnhancedLivestock#translations", "l10n/"),
        ["override"] = xmlFile:getBool("EnhancedLivestock#override", false)
    }

    xmlFile:delete()

    local l10nNames = {
        g_languageShort,
        "en",
        "de"
    }

    local l10nXML

    for _, l10nName in pairs(l10nNames) do
        l10nXML = XMLFile.loadIfExists("l10n", basePath .. ELSettings.customAnimals.translations .. "_" .. l10nName .. ".xml")
        if l10nXML ~= nil then
            break
        end
    end

    if l10nXML ~= nil then

        l10nXML:iterate("l10n.texts.text", function(_, key)

            local name = l10nXML:getString(key .. "#name")
            local text = l10nXML:getString(key .. "#text")

            if name ~= nil and text ~= nil then

                if g_i18n:hasModText(name) then
                    printWarning("Warning: Duplicate l10n entry \'" .. name .. "\'. Ignoring this definition.")
                else
                    g_i18n:setText(name, text:gsub("\r\n", "\n"))
                end

            end

        end)

        l10nXML:delete()

    end

    local fillTypesXML = loadXMLFile("fillTypes", basePath .. ELSettings.customAnimals.fillTypes)
    g_fillTypeManager:loadFillTypes(fillTypesXML, basePath, false, modName)

end