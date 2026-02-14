--[[
    ELMigrationManager.lua
    Handles migration from FS25_RealisticLivestock to FS25_EnhancedLivestock

    Migration responsibilities:
    1. Detect old mod conflict (both mods installed)
    2. Detect if migration is needed (old data exists, new data doesn't)
    3. Show migration dialog to user

    NON-DESTRUCTIVE MIGRATION APPROACH:
    All migration is handled via dual-read support in the loading code:
    - ELSettings.lua tries elSettings.xml first, falls back to rlSettings.xml
    - EnhancedLivestock_AnimalSystem.lua tries ELAnimalSystem.xml first, falls back to animalSystem.xml
    - ELItemSystemMigration.lua patches items.xml and handTools.xml in-memory

    When the game saves, it writes to the NEW filenames only, effectively completing
    the migration. The user can revert to the old mod before saving without data loss.

    NOTE: No state file is used because FS25 replaces the entire savegame folder on save,
    only preserving files written during the save callback. Migration detection relies on
    checking whether new files (ELSettings.xml) exist.

    based on Ritter FS25_RealisticLivestockRM
]]

ElMigrationManager = {}

local ElMigrationManager_mt = Class(ElMigrationManager)

-- Constants
ElMigrationManager.OLD_MOD_NAME = "FS25_RealisticLivestock"
ElMigrationManager.NEW_MOD_NAME = "FS25_EnhancedLivestock"

-- Old file names (for detection only - actual migration happens via dual-read)
ElMigrationManager.OLD_FILES = {
	"rlSettings.xml",
	"animalSystem.xml"
}

-- Mods that conflict with ours (e.g., extracted subsets of original Realistic Livestock)
ElMigrationManager.CONFLICTING_MODS = {
	"FS25_MoreVisualAnimals",
	"FS25_RealisticLivestockRM",
	"FS25_EnhancedAnimalSystem"
}

-- Global instance
g_ElMigrationManager = nil

-- Pending migration flag (set during load, dialog shown after GUI init)
g_elPendingMigration = false
g_elMigrationConflict = false


function ElMigrationManager.new()
	local self = setmetatable({}, ElMigrationManager_mt)
	self.savegameDir = nil
	return self
end


function ElMigrationManager:initialize(overrideSavegameDir)
-- Allow override of savegame directory (used for early migration before g_currentMission is ready)
	if overrideSavegameDir ~= nil then
		self.savegameDir = overrideSavegameDir
		return true
	end

	if g_currentMission == nil or g_currentMission.missionInfo == nil then
		return false
	end

	self.savegameDir = g_currentMission.missionInfo.savegameDirectory
	if self.savegameDir == nil then
		return false
	end

	return true
end


-- Set the savegame directory directly (for early migration)
function ElMigrationManager:setSavegameDir(savegameDir)
	self.savegameDir = savegameDir
end


--[[
    Check if any conflicting mods are ENABLED and LOADED.
    Collects ALL conflicts into self.conflictingMods so they can be shown
    in a single dialog (avoiding multiple restart cycles).
    Returns true if any conflict detected.

    Note: g_modNameToDirectory contains ALL mods in the folder (enabled or not)
          g_modIsLoaded contains only mods that are actually enabled and loaded
]]
function ElMigrationManager:checkModConflict()
	Logging.info("[EnhancedLivestock] ElMigrationManager: Checking for mod conflicts...")

	if g_modIsLoaded == nil then
		Logging.warning("[EnhancedLivestock] ElMigrationManager: g_modIsLoaded is nil!")
		return false
	end

	local found = {}

	-- Check old mod (original Realistic Livestock)
	if g_modIsLoaded[ElMigrationManager.OLD_MOD_NAME] == true then
		table.insert(found, ElMigrationManager.OLD_MOD_NAME)
	end

	-- Check known conflicting mods
	for _, modName in ipairs(ElMigrationManager.CONFLICTING_MODS) do
		if g_modIsLoaded[modName] == true then
			table.insert(found, modName)
		end
	end

	if #found > 0 then
		Logging.warning("[EnhancedLivestock] ElMigrationManager: Conflicting mods found: " .. table.concat(found, ", "))
		self.conflictingMods = found
		g_elMigrationConflict = true
		return true
	end

	Logging.info("[EnhancedLivestock] ElMigrationManager: No conflicts detected")
	return false
end


--[[
    Show conflict dialog listing ALL conflicting mods and block mission loading.
    Uses a short timer delay to ensure the dialog is shown after the game
    has fully transitioned to gameplay state, similar to how Courseplay
    shows its version dialog.
]]
function ElMigrationManager:showConflictDialog()
	Logging.info("[EnhancedLivestock] ElMigrationManager: showConflictDialog called, scheduling dialog...")

	-- Use a short delay to ensure the game has fully entered gameplay state
	-- before showing the dialog. This ensures the dialog properly overlays
	-- on top of the gameplay screen rather than getting lost during the
	-- loading-to-gameplay transition.
	Timer.createOneshot(100, function()
		Logging.info("[EnhancedLivestock] ElMigrationManager: Timer fired, showing conflict dialog now")

		local title = g_i18n:getText("el_conflict_title")
		local modList = ""
		for _, modName in ipairs(self.conflictingMods) do
			modList = modList .. "\n- " .. modName
		end
		local message = string.format(g_i18n:getText("el_mod_conflict_message"), modList)

		InfoDialog.show(title .. "\n\n" .. message, function()
			Logging.info("[EnhancedLivestock] ElMigrationManager: User acknowledged conflict, restarting game")
			-- Restart the game so user can disable the conflicting mod(s)
			doRestart(false, "")
		end, self)
	end)
end


--[[
    Check if migration is needed
    Returns true if:
    - Old data files exist AND
    - New data files don't exist
]]
function ElMigrationManager:shouldMigrate()
	if not self:initialize() then
		return false
	end

	-- Check for old data
	local hasOldSettings = fileExists(self.savegameDir .. "/rlSettings.xml")
	local hasOldAnimalSystem = fileExists(self.savegameDir .. "/animalSystem.xml")
	local hasOld = hasOldSettings or hasOldAnimalSystem

	if not hasOld then
		return false
	end

	-- Check for new data (if exists, no migration needed - user already saved with new mod)
	local hasNewSettings = fileExists(self.savegameDir .. "/elSettings.xml")
	if hasNewSettings then
		return false
	end

	return true
end


--[[
    Get list of old data files that exist
    Returns table with file info for display in migration dialog
]]
function ElMigrationManager:getOldDataFiles()
	if not self:initialize() then
		return {}
	end

	local files = {}

	if fileExists(self.savegameDir .. "/rlSettings.xml") then
		table.insert(files, { name = "rlSettings.xml", type = "Settings" })
	end

	if fileExists(self.savegameDir .. "/animalSystem.xml") then
		table.insert(files, { name = "animalSystem.xml", type = "Animal System" })
	end

	-- Check for Dewar items in items.xml (modName="FS25_RealisticLivestock")
	if self:hasOldItemsData() then
		table.insert(files, { name = "items.xml", type = "Dewars" })
	end

	-- Check for AI Straw hand tools in handTools.xml (filename contains $moddir$FS25_RealisticLivestock/)
	if self:hasOldHandToolsData() then
		table.insert(files, { name = "handTools.xml", type = "AI Straw Hand Tools" })
	end

	-- Check for HandToolAIStraw namespace data in items.xml (legacy namespace migration)
	local itemsPath = self.savegameDir .. "/items.xml"
	if fileExists(itemsPath) then
		local itemsXml = XMLFile.loadIfExists("items", itemsPath)
		if itemsXml ~= nil then
			local hasOldNamespace = false
			itemsXml:iterate("items.item", function(_, key)
				local oldKey = key .. ".FS25_RealisticLivestock.aiStraw"
				if itemsXml:hasProperty(oldKey) then
					hasOldNamespace = true
					return false -- Stop iteration
				end
			end)
			itemsXml:delete()

			if hasOldNamespace then
				table.insert(files, { name = "items.xml (namespace)", type = "AI Straw Data" })
			end
		end
	end

	return files
end


--[[
    Check if items.xml has old mod references (className/modName)
    This is different from namespace migration - this is about the item registration itself
]]
function ElMigrationManager:hasOldItemsData()
	if not self:initialize() then
		return false
	end

	local itemsPath = self.savegameDir .. "/items.xml"
	if not fileExists(itemsPath) then
		return false
	end

	local xmlFile = XMLFile.loadIfExists("items_check", itemsPath)
	if xmlFile == nil then
		return false
	end

	local hasOldData = false
	xmlFile:iterate("items.item", function(_, key)
		local modName = xmlFile:getString(key .. "#modName")
		if modName == ElMigrationManager.OLD_MOD_NAME then
			hasOldData = true
			return false -- Stop iteration
		end
	end)

	xmlFile:delete()
	return hasOldData
end


--[[
    Check if handTools.xml has old mod references in filename attribute
    Note: Hand tools don't have a modName attribute, they use filename with $moddir$ModName/ path
]]
function ElMigrationManager:hasOldHandToolsData()
	if not self:initialize() then
		return false
	end

	local handToolsPath = self.savegameDir .. "/handTools.xml"
	if not fileExists(handToolsPath) then
		return false
	end

	local xmlFile = XMLFile.loadIfExists("handTools_check", handToolsPath)
	if xmlFile == nil then
		return false
	end

	local hasOldData = false
	local oldModPath = "$moddir$" .. ElMigrationManager.OLD_MOD_NAME .. "/"

	xmlFile:iterate("handTools.handTool", function(_, key)
		local filename = xmlFile:getString(key .. "#filename")
		if filename ~= nil and string.find(filename, oldModPath, 1, true) then
			hasOldData = true
			return false -- Stop iteration
		end
	end)

	xmlFile:delete()
	return hasOldData
end


--[[
    Show migration dialog to user.
    Uses a short timer delay for consistency with showConflictDialog.
]]
function ElMigrationManager:showMigrationDialog()
	Logging.info("[EnhancedLivestock] ElMigrationManager: showMigrationDialog called, scheduling dialog...")

	Timer.createOneshot(100, function()
		Logging.info("[EnhancedLivestock] ElMigrationManager: Timer fired, showing migration dialog now")

		if ELMigrationDialog ~= nil and ELMigrationDialog.show ~= nil then
			local files = self:getOldDataFiles()
			ELMigrationDialog.show(files)
		else
			Logging.error("[EnhancedLivestock] ElMigrationManager: ELMigrationDialog not available")
		end
	end)
end