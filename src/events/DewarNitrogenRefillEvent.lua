DewarNitrogenRefillEvent = {}

local DewarNitrogenRefillEvent_mt = Class(DewarNitrogenRefillEvent, Event)
InitEventClass(DewarNitrogenRefillEvent, "DewarNitrogenRefillEvent")

function DewarNitrogenRefillEvent.emptyNew()

	local self = Event.new(DewarNitrogenRefillEvent_mt)
	return self

end

function DewarNitrogenRefillEvent.new(dewar)

	local event = DewarNitrogenRefillEvent.emptyNew()

	event.dewar = dewar
	event.uniqueId = dewar.uniqueId
	event.farmId = dewar:getOwnerFarmId()

	return event

end

function DewarNitrogenRefillEvent:readStream(streamId, connection)

	self.uniqueId = streamReadString(streamId)
	self.farmId = streamReadUInt8(streamId)

	self:run(connection)

end

function DewarNitrogenRefillEvent:writeStream(streamId, connection)

	streamWriteString(streamId, self.uniqueId)
	streamWriteUInt8(streamId, self.farmId)

end

function DewarNitrogenRefillEvent:run(connection)

	if not connection:getIsServer() then
		g_server:broadcastEvent(self)
	end

	-- Find the dewar and refill nitrogen
	local dewars = g_dewarManager:getDewarsByFarm(self.farmId)

	if dewars ~= nil then
		for _, animalDewars in pairs(dewars) do
			for _, dewar in pairs(animalDewars) do
				if dewar.uniqueId == self.uniqueId then
					dewar.nitrogenLevel = dewar.nitrogenCapacity
					dewar.lastUpdateDay = g_currentMission.environment.currentMonotonicDay
					return
				end
			end
		end
	end

end

function DewarNitrogenRefillEvent.sendEvent(dewar)

	if g_server ~= nil then
		g_server:broadcastEvent(DewarNitrogenRefillEvent.new(dewar))
	else
		g_client:getServerConnection():sendEvent(DewarNitrogenRefillEvent.new(dewar))
	end

end
