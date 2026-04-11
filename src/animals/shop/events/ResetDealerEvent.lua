ResetDealerEvent = {}

local ResetDealerEvent_mt = Class(ResetDealerEvent, Event)
InitEventClass(ResetDealerEvent, "ResetDealerEvent")

function ResetDealerEvent.emptyNew()
	local self = Event.new(ResetDealerEvent_mt)
	return self
end

function ResetDealerEvent.new()
	return ResetDealerEvent.emptyNew()
end

function ResetDealerEvent:readStream(streamId, connection)
	self:run(connection)
end

function ResetDealerEvent:writeStream(streamId, connection)
end

function ResetDealerEvent:run(connection)
	if not g_server then return end
	AnimalSystem.onClickResetDealer()
end

function ResetDealerEvent.sendEvent()
	if g_server ~= nil then
		AnimalSystem.onClickResetDealer()
	else
		g_client:getServerConnection():sendEvent(ResetDealerEvent.new())
	end
end
