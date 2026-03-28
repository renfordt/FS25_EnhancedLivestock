DewarManager = {}

local DewarManager_mt = Class(DewarManager)
local modDirectory = g_currentModDirectory

function DewarManager.new()

	local self = setmetatable({}, DewarManager_mt)

	self.farms = {}

	return self

end

function DewarManager:addDewar(farmId, dewar)

	if self.farms[farmId] == nil then
		self.farms[farmId] = {}
	end

	local farm = self.farms[farmId]
	local typeIndex = dewar.animal.typeIndex

	if farm[typeIndex] == nil then
		farm[typeIndex] = {}
	end

	table.insert(farm[typeIndex], dewar)

end

function DewarManager:removeDewar(farmId, dewar)

	local typeIndex = dewar.animal.typeIndex

	if self.farms[farmId] == nil or self.farms[farmId][typeIndex] == nil then
		return
	end

	local id = dewar:getUniqueId()

	for i, object in pairs(self.farms[farmId][typeIndex]) do

		if object:getUniqueId() == id then
			table.remove(self.farms[farmId][typeIndex], i)
			return
		end

	end

end

function DewarManager:getDewarsByFarm(farmId)

	return self.farms[farmId]

end

function DewarManager:onDayChanged()

	local currentDay = g_currentMission.environment.currentMonotonicDay

	for farmId, animalTypes in pairs(self.farms) do
		for animalTypeIndex, dewars in pairs(animalTypes) do
			local dewarsToDelete = {}

			for i, dewar in pairs(dewars) do
				if dewar.lastUpdateDay == nil then
					dewar.lastUpdateDay = currentDay
				end

				local daysPassed = currentDay - dewar.lastUpdateDay

				if daysPassed > 0 then
					-- Degrade nitrogen level
					dewar.nitrogenLevel = math.max(
						dewar.nitrogenLevel - (dewar.degradationRate * daysPassed),
						0
					)
					dewar.lastUpdateDay = currentDay

					-- Check for spoilage
					if dewar.nitrogenLevel <= 0 then
						-- Mark for deletion
						table.insert(dewarsToDelete, i)

						-- Show warning to farm owner
						if g_currentMission.isServer then
							g_currentMission:addIngameNotification(
								FSBaseMission.INGAME_NOTIFICATION_CRITICAL,
								string.format(
									g_i18n:getText("el_warning_dewarSpoiled"),
									dewar.uniqueId or "unknown"
								)
							)
						end
					end
				end
			end

			-- Delete spoiled dewars in reverse order to avoid index issues
			for i = #dewarsToDelete, 1, -1 do
				local dewar = dewars[dewarsToDelete[i]]
				dewar:delete()
			end
		end
	end

end

g_dewarManager = DewarManager.new()