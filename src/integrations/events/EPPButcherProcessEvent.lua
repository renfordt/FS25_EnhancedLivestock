---
-- EPPButcherProcessEvent
-- Client -> Server event when an EL animal is sent to an EPP butcher.
-- The server validates the animal, calculates meat yield, and processes the transaction.
---

EPPButcherProcessEvent = {}

local EPPButcherProcessEvent_mt = Class(EPPButcherProcessEvent, Event)
InitEventClass(EPPButcherProcessEvent, "EPPButcherProcessEvent")


function EPPButcherProcessEvent.emptyNew()
    local self = Event.new(EPPButcherProcessEvent_mt)
    return self
end


function EPPButcherProcessEvent.new(productionPoint, sourceObject, animal)
    local self = EPPButcherProcessEvent.emptyNew()

    self.productionPoint = productionPoint
    self.sourceObject = sourceObject
    self.animal = animal

    return self
end


function EPPButcherProcessEvent:readStream(streamId, connection)
    self.productionPoint = NetworkUtil.readNodeObject(streamId)

    local hasSourceObject = streamReadBool(streamId)
    self.sourceObject = hasSourceObject and NetworkUtil.readNodeObject(streamId) or nil

    -- Read animal identifiers
    self.animalIdentifiers = Animal.readStreamIdentifiers(streamId, connection)
    self.animalIdentifiers.subTypeIndex = streamReadUInt16(streamId)

    -- Read animal data needed for meat calculation
    self.animalData = {
        weight = streamReadFloat32(streamId),
        quality = streamReadFloat32(streamId),
        health = streamReadFloat32(streamId),
        subTypeIndex = streamReadUInt8(streamId)
    }

    self:run(connection)
end


function EPPButcherProcessEvent:writeStream(streamId, connection)
    NetworkUtil.writeNodeObject(streamId, self.productionPoint)

    streamWriteBool(streamId, self.sourceObject ~= nil)
    if self.sourceObject ~= nil then
        NetworkUtil.writeNodeObject(streamId, self.sourceObject)
    end

    -- Write animal identifiers
    self.animal:writeStreamIdentifiers(streamId, connection)
    streamWriteUInt16(streamId, self.animal.subTypeIndex or 1)

    -- Write animal data needed for meat calculation
    streamWriteFloat32(streamId, self.animal.weight or 100)
    streamWriteFloat32(streamId, self.animal.genetics and self.animal.genetics.quality or 1.0)
    streamWriteFloat32(streamId, self.animal.health or 100)
    streamWriteUInt8(streamId, self.animal.subTypeIndex or 1)
end


function EPPButcherProcessEvent:run(connection)
    -- Only process on server
    if not g_server then
        return
    end

    if self.productionPoint == nil then
        Logging.warning("[EL-EPP] EPPButcherProcessEvent: Production point is nil")
        return
    end

    -- Server-side processing
    local identifiers = self.animalIdentifiers
    local animalData = self.animalData

    -- Find and validate the animal exists
    local animal = nil
    local clusterSystem = nil

    if self.sourceObject ~= nil and self.sourceObject.getClusterSystem ~= nil then
        clusterSystem = self.sourceObject:getClusterSystem()
        if clusterSystem ~= nil and clusterSystem.animals ~= nil then
            for _, a in pairs(clusterSystem.animals) do
                if a.farmId == identifiers.farmId and
                   a.uniqueId == identifiers.uniqueId and
                   a.birthday and a.birthday.country == identifiers.country then
                    animal = a
                    break
                end
            end
        end
    end

    if animal == nil then
        -- Try global animal system
        local animalTypeIndex = identifiers.animalTypeIndex
        if animalTypeIndex == nil and identifiers.subTypeIndex ~= nil then
            local subType = g_currentMission.animalSystem:getSubTypeByIndex(identifiers.subTypeIndex)
            if subType ~= nil then
                animalTypeIndex = subType.typeIndex
            end
        end

        if animalTypeIndex ~= nil then
            local animals = g_currentMission.animalSystem.animals[animalTypeIndex]
            if animals ~= nil then
                for _, a in pairs(animals) do
                    if a.farmId == identifiers.farmId and
                       a.uniqueId == identifiers.uniqueId and
                       a.birthday and a.birthday.country == identifiers.country then
                        animal = a
                        break
                    end
                end
            end
        end
    end

    if animal == nil then
        Logging.warning("[EL-EPP] EPPButcherProcessEvent: Animal not found (farmId=%s, uniqueId=%s)",
            identifiers.farmId or "nil", identifiers.uniqueId or "nil")
        return
    end

    -- Calculate and process the meat yield
    local result = EL_EPPButcherIntegration.processAnimalOnServer(
        self.productionPoint,
        animal,
        animalData,
        clusterSystem
    )

    if result ~= nil and result.success then
        -- Broadcast result to all clients
        g_server:broadcastEvent(EPPButcherResultEvent.new(
            identifiers,
            result.meatYield,
            result.fillTypeIndex,
            result.fillTypeName
        ))
    end
end
