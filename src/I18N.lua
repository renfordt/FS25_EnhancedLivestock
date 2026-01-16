EL_I18N = {}
local modName = g_currentModName
local isGithubVersion = true

function EL_I18N:getText(superFunc, text, modEnv)

    if (text == "el_ui_monitorSubscriptions" or text == "finance_monitorSubscriptions" or text == "el_ui_herdsmanWages" or text == "finance_herdsmanWages" or text == "el_ui_semenPurchase" or text == "finance_semenPurchase") and modEnv == nil then
        return superFunc(self, text, modName)
    end

    if isGithubVersion and string.contains(text, "el_") then

        local env = self.modEnvironments[modName]

        if env == nil then return superFunc(self, text, modEnv) end

        if env.texts[text .. "_github"] ~= nil then return env.texts[text .. "_github"] end

    end

    return superFunc(self, text, modEnv)

end

I18N.getText = Utils.overwrittenFunction(I18N.getText, EL_I18N.getText)