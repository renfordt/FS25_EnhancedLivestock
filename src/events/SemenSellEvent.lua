--[[
	SemenSellEvent
	Event for selling semen from male animals in multiplayer
]]

SemenSellEvent = {}

local SemenSellEvent_mt = Class(SemenSellEvent, Event)

InitEventClass(SemenSellEvent, "SemenSellEvent")

-- Helper function to get animal display name with fallback to identifier
local function getAnimalDisplayName(animal)
	if animal == nil then
		return g_i18n:getText("el_ui_animal")
	end
	if animal.name ~= nil and animal.name ~= "" then
		return animal.name
	end
	-- Fallback to animal identifier (country code + farm ID + unique ID)
	local areaCode = EnhancedLivestock.AREA_CODES[animal.birthday.country]
	if areaCode ~= nil then
		return string.format("%s %s %s", areaCode.code, animal.farmId, animal.uniqueId)
	end
	return animal.uniqueId or g_i18n:getText("el_ui_animal")
end

function SemenSellEvent.emptyNew()
	local self = Event.new(SemenSellEvent_mt)
	return self
end

function SemenSellEvent.new(animal, quantity, price)
	local self = SemenSellEvent.emptyNew()

	self.animal = animal
	self.quantity = quantity
	self.price = price
	self.farmId = animal.farmId

	return self
end

function SemenSellEvent:readStream(streamId, connection)
	-- Read animal identification
	self.farmId = streamReadUInt8(streamId)
	local animalTypeIndex = streamReadUInt8(streamId)
	local uniqueId = streamReadString(streamId)

	-- Read transaction details
	self.quantity = streamReadUInt16(streamId)
	self.price = streamReadFloat32(streamId)

	-- Find the animal
	local farm = g_farmManager:getFarmById(self.farmId)
	if farm ~= nil then
		local animals = g_animalSystem:getAnimalsOfTypeForFarm(animalTypeIndex, self.farmId)
		if animals ~= nil then
			for _, animal in pairs(animals) do
				if animal.uniqueId == uniqueId then
					self.animal = animal
					break
				end
			end
		end
	end

	self:run(connection)
end

function SemenSellEvent:writeStream(streamId, connection)
	-- Write animal identification
	streamWriteUInt8(streamId, self.farmId)
	streamWriteUInt8(streamId, self.animal.animalTypeIndex)
	streamWriteString(streamId, self.animal.uniqueId)

	-- Write transaction details
	streamWriteUInt16(streamId, self.quantity)
	streamWriteFloat32(streamId, self.price)
end

function SemenSellEvent:run(connection)
	if not connection:getIsServer() then
		-- Client sent to server: process the sale and broadcast to all clients
		if self.animal == nil then
			print("Warning: SemenSellEvent - Animal not found")
			return
		end

		-- Add money to farm (server-side only)
		g_currentMission:addMoney(
			self.price,
			self.farmId,
			MoneyType.SEMEN_SALE,
			true
		)

		-- Update cooldown on server
		self.animal.lastSemenCollectionDay = g_currentMission.environment.currentMonotonicDay

		-- Broadcast to all clients
		g_server:broadcastEvent(self)
	end

	-- Show notification (on all clients and server)
	g_currentMission:addIngameNotification(
		FSBaseMission.INGAME_NOTIFICATION_OK,
		string.format(
			g_i18n:getText("el_notification_semenSold"),
			self.quantity,
			getAnimalDisplayName(self.animal),
			g_i18n:formatMoney(self.price)
		)
	)
end

function SemenSellEvent.sendEvent(animal, quantity, price)
	if g_server ~= nil then
		-- Server: execute logic locally (required for singleplayer where broadcast has no recipients)
		g_currentMission:addMoney(price, animal.farmId, MoneyType.SEMEN_SALE, true)
		animal.lastSemenCollectionDay = g_currentMission.environment.currentMonotonicDay
		g_currentMission:addIngameNotification(
			FSBaseMission.INGAME_NOTIFICATION_OK,
			string.format(
				g_i18n:getText("el_notification_semenSold"),
				quantity,
				getAnimalDisplayName(animal),
				g_i18n:formatMoney(price)
			)
		)
		-- Also broadcast to any connected clients (for multiplayer)
		g_server:broadcastEvent(SemenSellEvent.new(animal, quantity, price))
	else
		-- Client: send to server for processing
		g_client:getServerConnection():sendEvent(SemenSellEvent.new(animal, quantity, price))
	end
end
