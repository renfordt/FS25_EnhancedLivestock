EnhancedLivestock_PlayerInputComponent = {}

local modName = g_currentModName

function EnhancedLivestock_PlayerInputComponent:update(_)

	self.dewar = nil

	if self.player.isOwner then

		if g_inputBinding:getContextName() == PlayerInputComponent.INPUT_CONTEXT_NAME then

			local currentMission = g_currentMission
			local accessHandler = currentMission.accessHandler
			local vehicleInRange = currentMission.interactiveVehicleInRange
			local canAccess

			if vehicleInRange == nil then
				canAccess = false
			else
				canAccess = accessHandler:canPlayerAccess(vehicleInRange, self.player)
			end

			local closestNode = self.player.targeter:getClosestTargetedNodeFromType(PlayerInputComponent)
			self.player.hudUpdater:setCurrentRaycastTarget(closestNode)

			if not canAccess and closestNode ~= nil then

				local husbandryId, animalId = getAnimalFromCollisionNode(closestNode)

				if husbandryId ~= nil and husbandryId ~= 0 then

					local clusterHusbandry = currentMission.husbandrySystem:getClusterHusbandryById(husbandryId)
					if clusterHusbandry ~= nil then
						local placeable = clusterHusbandry:getPlaceable()
						local animal = clusterHusbandry:getClusterByAnimalId(animalId, husbandryId)

						if animal ~= nil and (accessHandler:canFarmAccess(self.player.farmId, placeable) and animal:getRidableFilename() ~= nil) then
							self.rideablePlaceable = placeable
							self.rideableCluster = animal

							local name = animal.getName == nil and "" or animal:getName()
							local text = string.format(g_i18n:getText("action_rideAnimal"), name)

							g_inputBinding:setActionEventText(self.enterActionId, text)
							g_inputBinding:setActionEventActive(self.enterActionId, true)
						end

					end

				else

					local object = g_currentMission:getNodeObject(closestNode)

					if object ~= nil and object:isa(Dewar) and object.straws > 0 then

						self.dewar = object

						g_inputBinding:setActionEventText(self.enterActionId, g_i18n:getText("el_ui_takeStraw"))
						g_inputBinding:setActionEventActive(self.enterActionId, true)

					end

				end

			end

		end

	end

end

PlayerInputComponent.update = Utils.appendedFunction(PlayerInputComponent.update, EnhancedLivestock_PlayerInputComponent.update)

function EnhancedLivestock_PlayerInputComponent:onInputEnter()

	if g_time <= g_currentMission.lastInteractionTime + 200 or g_currentMission.interactiveVehicleInRange ~= nil or self.rideablePlaceable ~= nil or self.dewar == nil or HandToolAIStraw.numHeldStraws > 10 then
		return
	end

	local strawType = g_handToolTypeManager:getTypeByName(modName .. ".aiStraw")
	local handTool = _G[strawType.className].new(g_currentMission:getIsServer(), g_currentMission:getIsClient())

	handTool:setType(strawType)
	handTool:setLoadCallback(self.onFinishedLoadStraw, self, { ["animal"] = self.dewar:getAnimal(), ["dewarUniqueId"] = self.dewar:getUniqueId(), ["semenType"] = self.dewar.semenType })
	handTool:loadNonStoreItem({ ["ownerFarmId"] = g_localPlayer.farmId, ["isRegistered"] = false, ["holder"] = g_localPlayer }, ELHandTools.xmlPaths.aiStraw)

	self.dewar:changeStraws(-1)

end

PlayerInputComponent.onInputEnter = Utils.appendedFunction(PlayerInputComponent.onInputEnter, EnhancedLivestock_PlayerInputComponent.onInputEnter)

function PlayerInputComponent:onFinishedLoadStraw(handTool, loadingState, args)

	if loadingState == HandToolLoadingState.OK then
		handTool:setAnimal(args.animal)
		handTool:setDewarUniqueId(args.dewarUniqueId)
		handTool:setSemenType(args.semenType)
	end

end

function EnhancedLivestock_PlayerInputComponent:registerGlobalPlayerActionEvents()

	VisualAnimalsDialog.register()

	g_inputBinding:registerActionEvent(InputAction.VisualAnimalsDialog, VisualAnimalsDialog, VisualAnimalsDialog.show, false, true, false, true, nil, true)

end

PlayerInputComponent.registerGlobalPlayerActionEvents = Utils.appendedFunction(PlayerInputComponent.registerGlobalPlayerActionEvents, EnhancedLivestock_PlayerInputComponent.registerGlobalPlayerActionEvents)

function EnhancedLivestock_PlayerInputComponent.onFinishedRideBlending(superFunc, _, args)
	local placeable = args[1]
	placeable:startRiding(args[2].farmId .. " " .. args[2].uniqueId, args[3])
end

PlayerInputComponent.onFinishedRideBlending = Utils.overwrittenFunction(PlayerInputComponent.onFinishedRideBlending, EnhancedLivestock_PlayerInputComponent.onFinishedRideBlending)
function AnimalRidingEvent:writeStream(streamId, _)
	NetworkUtil.writeNodeObject(streamId, self.husbandry)
	streamWriteString(streamId, tostring(self.clusterId))
	NetworkUtil.writeNodeObject(streamId, self.player)
end

function AnimalRidingEvent:readStream(streamId, _)
	self.husbandry = NetworkUtil.readNodeObject(streamId)
	self.clusterId = streamReadString(streamId)
	self.player = NetworkUtil.readNodeObject(streamId)
	self:run(nil)
end

function AnimalCleanEvent:writeStream(streamId, _)
	NetworkUtil.writeNodeObject(streamId, self.husbandry)
	streamWriteString(streamId, tostring(self.clusterId))
	streamWriteUIntN(streamId, self.delta, AnimalClusterHorse.NUM_BITS_DIRT)
end

function AnimalCleanEvent:readStream(streamId, connection)
	self.husbandry = NetworkUtil.readNodeObject(streamId)
	self.clusterId = streamReadString(streamId)
	self.delta = streamReadUIntN(streamId, AnimalClusterHorse.NUM_BITS_DIRT)
	self:run(connection)
end

function AnimalCleanEvent:run(connection)
	if self.husbandry ~= nil then
		local cluster = self.husbandry:getClusterById(self.clusterId)
		if cluster ~= nil and cluster.changeDirt ~= nil then
			cluster:changeDirt(-self.delta)
		end
	end

	if connection ~= nil and not connection:getIsServer() then
		g_server:broadcastEvent(AnimalCleanEvent.new(self.husbandry, self.clusterId, self.delta))
	end
end

function Rideable:onWriteStream(streamId, connection)
	local spec = self.spec_rideable

	if not connection:getIsServer() then
		streamWriteBool(streamId, spec.isOnGround)
	end

	local cluster = spec.cluster
	if streamWriteBool(streamId, cluster ~= nil) then
		streamWriteUIntN(streamId, cluster:getSubTypeIndex(), AnimalCluster.NUM_BITS_SUB_TYPE)
		streamWriteUIntN(streamId, cluster.numAnimals or 1, AnimalCluster.NUM_BITS_NUM_ANIMALS)
		streamWriteUIntN(streamId, math.floor(cluster.age or 0), AnimalCluster.NUM_BITS_AGE)
		streamWriteUIntN(streamId, math.floor(cluster.health or 0), AnimalCluster.NUM_BITS_HEALTH)
		streamWriteUIntN(streamId, math.floor(cluster.reproduction or 0), AnimalCluster.NUM_BITS_REPRODUCTION)
		streamWriteString(streamId, cluster.name or "")
		streamWriteUIntN(streamId, math.floor(cluster.fitness or 0), AnimalClusterHorse.NUM_BITS_FITNESS)
		streamWriteUIntN(streamId, math.floor(cluster.riding or 0), AnimalClusterHorse.NUM_BITS_RIDING)
		streamWriteUIntN(streamId, math.floor(cluster.dirt or 0), AnimalClusterHorse.NUM_BITS_DIRT)
	end

	if streamWriteBool(streamId, spec.playerToEnter ~= nil) then
		NetworkUtil.writeNodeObject(streamId, spec.playerToEnter)
	end
end

function Rideable:onWriteUpdateStream(streamId, connection, _)
	local spec = self.spec_rideable
	if connection:getIsServer() then
		streamWriteFloat32(streamId, spec.inputValues.axisSteerSend)
		streamWriteUInt8(streamId, spec.inputValues.currentGait)
	else
		streamWriteFloat32(streamId, spec.haltTimer)
		local cluster = spec.cluster
		if streamWriteBool(streamId, cluster ~= nil) then
		-- Write AnimalClusterHorse update format: fitness, riding, dirt
			streamWriteUIntN(streamId, math.floor(cluster.fitness or 0), AnimalClusterHorse.NUM_BITS_FITNESS)
			streamWriteUIntN(streamId, math.floor(cluster.riding or 0), AnimalClusterHorse.NUM_BITS_RIDING)
			streamWriteUIntN(streamId, math.floor(cluster.dirt or 0), AnimalClusterHorse.NUM_BITS_DIRT)
		end
	end
end