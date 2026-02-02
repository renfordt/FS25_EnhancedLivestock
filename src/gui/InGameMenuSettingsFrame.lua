EL_InGameMenuSettingsFrame = {}

function EL_InGameMenuSettingsFrame:onFrameOpen(_)

    for name, setting in pairs(ELSettings.SETTINGS) do

        if setting.dependancy then
            local dependancy = ELSettings.SETTINGS[setting.dependancy.name]
            if dependancy ~= nil and setting.element ~= nil then
                setting.element:setDisabled(dependancy.state ~= setting.dependancy.state)
            end
        end

    end

end

InGameMenuSettingsFrame.onFrameOpen = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameOpen, EL_InGameMenuSettingsFrame.onFrameOpen)

function EL_InGameMenuSettingsFrame:onFrameClose()

    if g_server ~= nil then
        ELSettings.saveToXMLFile()
    end

    EL_BroadcastSettingsEvent.sendEvent()

end

InGameMenuSettingsFrame.onFrameClose = Utils.appendedFunction(InGameMenuSettingsFrame.onFrameClose, EL_InGameMenuSettingsFrame.onFrameClose)