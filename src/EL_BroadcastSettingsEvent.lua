EL_BroadcastSettingsEvent = {}

local EL_BroadcastSettingsEvent_mt = Class(EL_BroadcastSettingsEvent, Event)
InitEventClass(EL_BroadcastSettingsEvent, "EL_BroadcastSettingsEvent")

function EL_BroadcastSettingsEvent.emptyNew()
    local self = Event.new(EL_BroadcastSettingsEvent_mt)
    return self
end

function EL_BroadcastSettingsEvent.new(setting)

    local self = EL_BroadcastSettingsEvent.emptyNew()

    self.setting = setting

    return self

end

function EL_BroadcastSettingsEvent:readStream(streamId, connection)

    local readAll = streamReadBool(streamId)

    if readAll then

        for _, setting in pairs(ELSettings.SETTINGS) do

            if setting.ignore then
                continue
            end

            local name = streamReadString(streamId)
            local state = streamReadUInt8(streamId)

            ELSettings.SETTINGS[name].state = state

        end

    else

        local name = streamReadString(streamId)
        local state = streamReadUInt8(streamId)

        ELSettings.SETTINGS[name].state = state
        self.setting = name

    end

    self:run(connection)

end

function EL_BroadcastSettingsEvent:writeStream(streamId, connection)

    streamWriteBool(streamId, self.setting == nil)

    if self.setting == nil then

        for name, setting in pairs(ELSettings.SETTINGS) do
            if setting.ignore then
                continue
            end
            streamWriteString(streamId, name)
            streamWriteUInt8(streamId, setting.state)
        end

    else

        local setting = ELSettings.SETTINGS[self.setting]
        streamWriteString(streamId, self.setting)
        streamWriteUInt8(streamId, setting.state)

    end

end

function EL_BroadcastSettingsEvent:run(connection)

    if self.setting == nil then

        for name, setting in pairs(ELSettings.SETTINGS) do
            if setting.ignore then
                continue
            end
            setting.element:setState(setting.state)
            if setting.callback ~= nil then
                setting.callback(name, setting.values[setting.state])
            end
        end

    else

        local setting = ELSettings.SETTINGS[self.setting]
        if setting.element ~= nil then
            setting.element:setState(setting.state)
        end
        if setting.callback ~= nil then
            setting.callback(self.setting, setting.values[setting.state])
        end

        if setting.dynamicTooltip and setting.element ~= nil then
            setting.element.elements[1]:setText(g_i18n:getText("el_settings_" .. self.setting .. "_tooltip_" .. setting.state))
        end

        for _, s in pairs(ELSettings.SETTINGS) do
            if s.dependancy and s.dependancy.name == self.setting and s.element ~= nil then
                s.element:setDisabled(s.dependancy.state ~= state)
            end
        end

        if g_server ~= nil then
            ELSettings.saveToXMLFile()
        end

    end

end

function EL_BroadcastSettingsEvent.sendEvent(setting)
    if g_server ~= nil then
        g_server:broadcastEvent(EL_BroadcastSettingsEvent.new(setting))
    else
        g_client:getServerConnection():sendEvent(EL_BroadcastSettingsEvent.new(setting))
    end
end