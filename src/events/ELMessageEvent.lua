ELMessageEvent = {}

local ELMessageEvent_mt = Class(ELMessageEvent, Event)
InitEventClass(ELMessageEvent, "ELMessageEvent")

function ELMessageEvent.emptyNew()

	local self = Event.new(ELMessageEvent_mt)
	return self

end

function ELMessageEvent.new(object, id, animal, args)

	local event = ELMessageEvent.emptyNew()

	event.object = object
	event.id = id
	event.animal = animal
	event.args = args or {}

	return event

end

function ELMessageEvent:readStream(streamId, connection)

	self.object = NetworkUtil.readNodeObject(streamId)
	self.id = streamReadString(streamId)

	if streamReadBool(streamId) then
		self.animal = streamReadString(streamId)
	end

	local numArgs = streamReadUInt8(streamId)
	self.args = {}

	for i = 1, numArgs do
		table.insert(self.args, streamReadString(streamId))
	end

	self:run(connection)

end

function ELMessageEvent:writeStream(streamId, connection)

	NetworkUtil.writeNodeObject(streamId, self.object)
	streamWriteString(streamId, self.id)

	streamWriteBool(streamId, self.animal ~= nil)

	if self.animal ~= nil then
		streamWriteString(streamId, self.animal)
	end

	self.args = self.args or {}
	streamWriteUInt8(streamId, #self.args)

	for i = 1, #self.args do
		streamWriteString(streamId, self.args[i])
	end

end

function ELMessageEvent:run(connection)

	if self.object ~= nil and self.object.addELMessage ~= nil then
		self.object:addELMessage(self.id, self.animal, self.args)

		if g_server ~= nil then
			g_server:broadcastEvent(ELMessageEvent.new(self.object, self.id, self.animal, self.args))
		end
	else
		Logging.warning("[EnhancedLivestock] ELMessageEvent:run() - object is nil or missing addELMessage, message '%s' dropped", tostring(self.id))
	end

end

function ELMessageEvent.sendEvent(object, id, animal, args)

	if g_server ~= nil then
		if object ~= nil and object.addELMessage ~= nil then
			object:addELMessage(id, animal, args)
		end

		g_server:broadcastEvent(ELMessageEvent.new(object, id, animal, args))
	else
		g_client:getServerConnection():sendEvent(ELMessageEvent.new(object, id, animal, args))
	end

end
