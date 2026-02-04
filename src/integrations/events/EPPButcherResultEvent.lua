---
-- EPPButcherResultEvent
-- Server -> Client broadcast event to notify all clients about butcher processing results.
-- Used for displaying notifications and synchronizing state.
---

EPPButcherResultEvent = {}

local EPPButcherResultEvent_mt = Class(EPPButcherResultEvent, Event)
InitEventClass(EPPButcherResultEvent, "EPPButcherResultEvent")

function EPPButcherResultEvent.emptyNew()
	local self = Event.new(EPPButcherResultEvent_mt)
	return self
end

function EPPButcherResultEvent.new(animalIdentifiers, meatYield, fillTypeIndex, fillTypeName)
	local self = EPPButcherResultEvent.emptyNew()

	self.animalIdentifiers = animalIdentifiers
	self.meatYield = meatYield
	self.fillTypeIndex = fillTypeIndex
	self.fillTypeName = fillTypeName

	return self
end

function EPPButcherResultEvent:readStream(streamId, connection)
-- Read animal identifiers
	self.animalIdentifiers = {
		uniqueId = streamReadString(streamId),
		farmId = streamReadString(streamId),
		country = streamReadUInt8(streamId),
		animalTypeIndex = streamReadUInt8(streamId)
	}

	-- Read result data
	self.meatYield = streamReadFloat32(streamId)
	self.fillTypeIndex = streamReadUInt8(streamId)
	self.fillTypeName = streamReadString(streamId)

	self:run(connection)
end

function EPPButcherResultEvent:writeStream(streamId, connection)
-- Write animal identifiers
	streamWriteString(streamId, self.animalIdentifiers.uniqueId or "")
	streamWriteString(streamId, self.animalIdentifiers.farmId or "")
	streamWriteUInt8(streamId, self.animalIdentifiers.country or 1)
	streamWriteUInt8(streamId, self.animalIdentifiers.animalTypeIndex or 1)

	-- Write result data
	streamWriteFloat32(streamId, self.meatYield or 0)
	streamWriteUInt8(streamId, self.fillTypeIndex or 0)
	streamWriteString(streamId, self.fillTypeName or "UNKNOWN")
end

function EPPButcherResultEvent:run(connection)
-- Display notification to the player
	local animalTypeName = EL_EPPButcherIntegration.getAnimalTypeName(self.animalIdentifiers.animalTypeIndex)
	local yieldText = string.format("%.1f", self.meatYield)
	local fillTypeTitle = g_fillTypeManager:getFillTypeTitleByIndex(self.fillTypeIndex) or self.fillTypeName

	local message = string.format(
		g_i18n:getText("el_epp_butcher_processed") or "Animal processed at butcher: %s kg of %s",
		yieldText,
		fillTypeTitle
	)

	g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_INFO, message)
end
