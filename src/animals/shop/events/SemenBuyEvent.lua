SemenBuyEvent = {}

local SemenBuyEvent_mt = Class(SemenBuyEvent, Event)
InitEventClass(SemenBuyEvent, "SemenBuyEvent")

function SemenBuyEvent.emptyNew()

	local self = Event.new(SemenBuyEvent_mt)
	return self

end

function SemenBuyEvent.new(animal, quantity, price, farmId, position, rotation, semenType)

	local event = SemenBuyEvent.emptyNew()

	event.animal = animal
	event.quantity = quantity
	event.price = price
	event.farmId = farmId
	event.position = position
	event.rotation = rotation
	event.semenType = semenType or SemenType.CONVENTIONAL

	return event

end

function SemenBuyEvent.newServerToClient(errorCode)

	local event = SemenBuyEvent.emptyNew()

	event.errorCode = errorCode

	return event

end

function SemenBuyEvent:readStream(streamId, connection)

	self.animal = Animal.new()
	self.animal:readStream(streamId, connection)
	self.animal.success = streamReadFloat32(streamId)

	self.quantity = streamReadUInt16(streamId)
	self.price = streamReadFloat32(streamId)
	self.farmId = streamReadUInt8(streamId)

	local x = streamReadFloat32(streamId)
	local y = streamReadFloat32(streamId)
	local z = streamReadFloat32(streamId)

	local rx = streamReadFloat32(streamId)
	local ry = streamReadFloat32(streamId)
	local rz = streamReadFloat32(streamId)

	self.position = { x, y, z }
	self.rotation = { rx, ry, rz }

	-- Read bull tier and semen type
	self.animal.bullTier = streamReadUInt8(streamId)
	self.semenType = streamReadUInt8(streamId)

	-- Read stock data
	self.animal.availableStraws = streamReadUInt16(streamId)

	self:run(connection)

end

function SemenBuyEvent:writeStream(streamId, connection)

	self.animal:writeStream(streamId, connection)
	streamWriteFloat32(streamId, self.animal.success or 0.65)

	streamWriteUInt16(streamId, self.quantity)
	streamWriteFloat32(streamId, self.price)
	streamWriteUInt8(streamId, self.farmId)

	streamWriteFloat32(streamId, self.position[1])
	streamWriteFloat32(streamId, self.position[2])
	streamWriteFloat32(streamId, self.position[3])

	streamWriteFloat32(streamId, self.rotation[1])
	streamWriteFloat32(streamId, self.rotation[2])
	streamWriteFloat32(streamId, self.rotation[3])

	-- Write bull tier and semen type
	streamWriteUInt8(streamId, self.animal.bullTier or BullTier.PROVEN)
	streamWriteUInt8(streamId, self.semenType or SemenType.CONVENTIONAL)

	-- Write stock data
	streamWriteUInt16(streamId, self.animal.availableStraws or 0)

	self:run(connection)

end

function SemenBuyEvent:run(connection)

	local dewar = Dewar.new(g_currentMission:getIsServer(), g_currentMission:getIsClient())

	dewar:setOwnerFarmId(self.farmId)

	-- Set semen type and fertility modifier
	dewar.semenType = self.semenType or SemenType.CONVENTIONAL
	if dewar.semenType == SemenType.SEXED_FEMALE or dewar.semenType == SemenType.SEXED_MALE then
		dewar.fertilityModifier = 0.85  -- -15% fertility for sexed semen
		-- Apply fertility penalty to animal success rate
		if self.animal.success ~= nil then
			self.animal.success = self.animal.success * dewar.fertilityModifier
		end
	end

	dewar:register(self.position, self.rotation, self.animal, self.quantity)

	-- Deduct stock from AI animal on server
	if g_server ~= nil and self.animal.bullTier ~= nil then
		local animalSystem = g_currentMission.animalSystem
		if animalSystem ~= nil and animalSystem.aiAnimals ~= nil then
			local typeAnimals = animalSystem.aiAnimals[self.animal.animalTypeIndex]
			if typeAnimals ~= nil then
				for _, aiAnimal in ipairs(typeAnimals) do
					if aiAnimal.birthday.country == self.animal.birthday.country and
					   aiAnimal.farmId == self.animal.farmId and
					   aiAnimal.uniqueId == self.animal.uniqueId then
						if aiAnimal.availableStraws ~= nil then
							aiAnimal.availableStraws = math.max(0, aiAnimal.availableStraws - self.quantity)
						end
						break
					end
				end
			end
		end
	end

	g_currentMission:addMoney(self.price, self.farmId, MoneyType.SEMEN_PURCHASE, true, true)

end