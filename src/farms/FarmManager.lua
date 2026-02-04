EL_FarmManager = {}

function EL_FarmManager:loadFromXMLFile(superFunc, path)

	print("EL_FarmManager: loadFromXMLFile called")

	-- Initialize migration manager and check for conflicts/migration needs (server only)
	-- NOTE: Early migration (items.xml, handTools.xml) is now handled by RmItemSystemMigration
	-- which hooks into ItemSystem.loadItems and runs BEFORE items are loaded.
	-- Here we only check for mod conflicts and set flags for showing dialogs.
	if g_currentMission:getIsServer() then
		print("EL_FarmManager: Running on server, checking migration state...")

		-- Create migration manager instance if not already created by RmItemSystemMigration
		if g_ElMigrationManager == nil then
			print("EL_FarmManager: Creating ElMigrationManager instance")
			g_ElMigrationManager = ElMigrationManager.new()
		end

		-- Check for mod conflict (both old and new mod installed)
		if g_ElMigrationManager:checkModConflict() then
		-- Conflict detected - will show dialog in onStartMission
			print("EL_FarmManager: Conflict detected!")
			g_elMigrationConflict = true
		elseif not g_elPendingMigration and g_ElMigrationManager:shouldMigrate() then
		-- Migration needed but wasn't handled by ELItemSystemMigration (shouldn't happen normally)
		-- This is a fallback in case ItemSystem hook didn't run
			print("EL_FarmManager: Migration needed (fallback path)!")
			g_elPendingMigration = true
		else
			print("EL_FarmManager: No conflict detected, migration state = " .. tostring(g_elPendingMigration))
		end

		print("EL_FarmManager: g_elMigrationConflict = " .. tostring(g_elMigrationConflict))
		print("EL_FarmManager: g_elPendingMigration = " .. tostring(g_elPendingMigration))
	else
		print("EL_FarmManager: Not running on server, skipping migration check")
	end
	

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