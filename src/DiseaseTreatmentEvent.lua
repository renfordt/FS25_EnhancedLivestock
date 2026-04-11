DiseaseTreatmentEvent = {}

local DiseaseTreatmentEvent_mt = Class(DiseaseTreatmentEvent, Event)
InitEventClass(DiseaseTreatmentEvent, "DiseaseTreatmentEvent")

function DiseaseTreatmentEvent.emptyNew()
	local self = Event.new(DiseaseTreatmentEvent_mt)
	return self
end

function DiseaseTreatmentEvent.new(object, animal, diseaseTitle, beingTreated)

	local self = DiseaseTreatmentEvent.emptyNew()

	self.object = object
	self.animal = animal
	self.diseaseTitle = diseaseTitle
	self.beingTreated = beingTreated

	return self

end

function DiseaseTreatmentEvent:readStream(streamId, connection)

	self.object = NetworkUtil.readNodeObject(streamId)
	self.animal = Animal.readStreamIdentifiers(streamId, connection)
	self.diseaseTitle = streamReadString(streamId)
	self.beingTreated = streamReadBool(streamId)

	self:run(connection)

end

function DiseaseTreatmentEvent:writeStream(streamId, connection)

	NetworkUtil.writeNodeObject(streamId, self.object)
	self.animal:writeStreamIdentifiers(streamId, connection)
	streamWriteString(streamId, self.diseaseTitle)
	streamWriteBool(streamId, self.beingTreated)

end

function DiseaseTreatmentEvent:run(connection)

	local clusterSystem = self.object:getClusterSystem()
	local identifiers = self.animal

	for _, animal in pairs(clusterSystem.animals) do

		if animal.farmId == identifiers.farmId and animal.uniqueId == identifiers.uniqueId and animal.birthday.country == (identifiers.country or identifiers.birthday.country) and animal.animalTypeIndex == identifiers.animalTypeIndex then

			-- Find the disease by title
			for _, disease in pairs(animal.diseases) do

				if disease.type.title == self.diseaseTitle then

					disease.beingTreated = self.beingTreated

					-- If starting treatment, set the treatment duration with late penalty
					if self.beingTreated and disease.treatmentDuration == 0 then
						local baseDuration = disease.type.treatment.duration
						local latePenalty = 1.0

						-- Apply penalty for treating late
						if disease.time > 3 then
							latePenalty = 2.0  -- Very late: double treatment time
						elseif disease.time > 1 then
							latePenalty = 1.5  -- Moderately late: 50% longer
						end

						disease.treatmentDuration = math.ceil(baseDuration * latePenalty)
					end

					return

				end

			end

		end

	end

end
