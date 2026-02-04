--[[
    ELMigrationDialog.lua
    Dialog for prompting user about data migration from old RealisticLivestock mod
    based on Ritter FS25_RealisticLivestockRM
]]

ELMigrationDialog = {}

local ELMigrationDialog_mt = Class(ELMigrationDialog, MessageDialog)
local modDirectory = g_currentModDirectory

-- Singleton instance
ELMigrationDialog.INSTANCE = nil


function ELMigrationDialog.register()
	local dialog = ELMigrationDialog.new()
	g_gui:loadGui(modDirectory .. "gui/ELMigrationDialog.xml", "ELMigrationDialog", dialog)
	ELMigrationDialog.INSTANCE = dialog
end


function ELMigrationDialog.new(target, customMt)
	local self = MessageDialog.new(target, customMt or ELMigrationDialog_mt)
	self.files = {}
	return self
end


function ELMigrationDialog.show(files)
	if ELMigrationDialog.INSTANCE == nil then
		ELMigrationDialog.register()
	end

	local dialog = ELMigrationDialog.INSTANCE
	dialog.files = files or {}
	dialog:setDialogType(DialogElement.TYPE_INFO)
	dialog:updateContent()

	g_gui:showDialog("ELMigrationDialog")
end


function ELMigrationDialog:onOpen()
	ELMigrationDialog:superClass().onOpen(self)
	FocusManager:setFocus(self.continueButton)
end


function ELMigrationDialog:onClose()
	ELMigrationDialog:superClass().onClose(self)
	self.files = {}
end


function ELMigrationDialog:onCreate()
	ELMigrationDialog:superClass().onCreate(self)
end


function ELMigrationDialog:updateContent()
-- Update title
	if self.titleElement ~= nil then
		self.titleElement:setText(g_i18n:getText("el_migration_title"))
	end

	-- Update message
	if self.messageElement ~= nil then
		self.messageElement:setText(g_i18n:getText("el_migration_message"))
	end

	-- Update file list
	if self.fileListElement ~= nil then
		local fileText = ""
		for _, file in ipairs(self.files) do
			fileText = fileText .. "- " .. file.name .. " (" .. file.type .. ")\n"
		end
		self.fileListElement:setText(fileText)
	end
end


--[[
    User clicked "Continue" button
    Close the dialog and continue loading - migration happens automatically via dual-read/new-save
]]
function ELMigrationDialog:onClickContinue()
	self:close()
end


--[[
    User clicked "Quit" button
    Exit to main menu
]]
function ELMigrationDialog:onClickQuit()
	doRestart(false, "")
end