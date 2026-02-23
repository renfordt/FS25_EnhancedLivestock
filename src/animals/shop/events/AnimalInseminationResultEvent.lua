AnimalInseminationResultEvent = {}

local AnimalInseminationResultEvent_mt = Class(AnimalInseminationResultEvent, Event)
InitEventClass(AnimalInseminationResultEvent, "AnimalInseminationResultEvent")

function AnimalInseminationResultEvent.emptyNew()

	local self = Event.new(AnimalInseminationResultEvent_mt)
	return self

end

function AnimalInseminationResultEvent.new(object, animal, success)

	local event = AnimalInseminationResultEvent.emptyNew()

	event.object = object
	event.animal = animal
	event.success = success

	return event

end

function AnimalInseminationResultEvent:readStream(streamId, connection)

	self.object = NetworkUtil.readNodeObject(streamId)
	self.animal = Animal.readStreamIdentifiers(streamId, connection)
	self.success = streamReadBool(streamId)

	self:run(connection)

end

function AnimalInseminationResultEvent:writeStream(streamId, connection)

	NetworkUtil.writeNodeObject(streamId, self.object)
	self.animal:writeStreamIdentifiers(streamId, connection)
	streamWriteBool(streamId, self.success)

end

function AnimalInseminationResultEvent:run(connection)

end