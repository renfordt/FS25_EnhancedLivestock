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

function DewarManager:readStream(streamId, connection)

	local numFarms = streamReadUInt8(streamId)
	self.farms = {}

	for farmIndex = 1, numFarms do

		local farmId = streamReadUInt8(streamId)
		local numAnimalTypes = streamReadUInt8(streamId)
		local farm = {}

		for animalIndex = 1, numAnimalTypes do

			local animalTypeIndex = streamReadUInt8(streamId)
			local numDewars = streamReadUInt8(streamId)
			local dewars = {}

			for dewarIndex = 1, numDewars do

				local dewar = Dewar.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())
				dewar:createNode(modDirectory .. "objects/dewar/dewar.i3d")
				dewar:readStream(streamId, connection)
				dewar:register()

				table.insert(dewars, dewar)

			end

			farm[animalTypeIndex] = dewars

		end

		self.farms[farmId] = farm

	end

end

function DewarManager:writeStream(streamId, connection)

	local numFarms = 0

	for farmId, animalTypes in pairs(self.farms) do
		numFarms = numFarms + 1
	end

	streamWriteUInt8(streamId, numFarms)

	for farmId, animalTypes in pairs(self.farms) do

		local numAnimalTypes = 0

		for animalTypeIndex, dewars in pairs(animalTypes) do
			numAnimalTypes = numAnimalTypes + 1
		end

		streamWriteUInt8(streamId, farmId)
		streamWriteUInt8(streamId, numAnimalTypes)

		for animalTypeIndex, dewars in pairs(animalTypes) do

			streamWriteUInt8(streamId, animalTypeIndex)
			streamWriteUInt8(streamId, #dewars)

			for _, dewar in pairs(dewars) do
				dewar:writeStream(streamId, connection)
			end

		end

	end

end

g_dewarManager = DewarManager.new()