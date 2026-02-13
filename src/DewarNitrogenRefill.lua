DewarNitrogenRefill = {}

DewarNitrogenRefill.ActionId = nil
DewarNitrogenRefill.Target = nil

function DewarNitrogenRefill.RefillAction()

	if DewarNitrogenRefill.Target == nil then
		return
	end

	local dewar = DewarNitrogenRefill.Target

	-- Check if player has access to this dewar's farm
	local farmId = dewar:getOwnerFarmId()
	if not g_currentMission.accessHandler:canFarmAccessOtherId(g_localPlayer:getFarmId(), farmId) then
		g_currentMission:showBlinkingWarning(g_i18n:getText("warning_youDontHaveAccessToThisLand"), 2000)
		return
	end

	dewar:refillNitrogen()

end

PlayerInputComponent.registerGlobalPlayerActionEvents = Utils.appendedFunction(PlayerInputComponent.registerGlobalPlayerActionEvents, function()

	if DewarNitrogenRefill.ActionId == nil then
		local valid, actionId = g_inputBinding:registerActionEvent(InputAction.RefillDewarNitrogen, DewarNitrogenRefill, DewarNitrogenRefill.RefillAction, false, true, false, false)
		if valid then
			DewarNitrogenRefill.ActionId = actionId
			g_inputBinding:setActionEventText(actionId, g_i18n:getText("el_action_refillNitrogen"))
			g_inputBinding:setActionEventTextPriority(actionId, GS_PRIO_VERY_HIGH)
			g_inputBinding:setActionEventActive(actionId, false)
		end
	end

end)

function DewarNitrogenRefill.UpdateActionEvents()

	if DewarNitrogenRefill.ActionId == nil then
		return
	end

	local isActive = DewarNitrogenRefill.Target ~= nil

	g_inputBinding:setActionEventActive(DewarNitrogenRefill.ActionId, isActive)

	if isActive then
		g_inputBinding:setActionEventTextPriority(DewarNitrogenRefill.ActionId, GS_PRIO_VERY_HIGH)
	end

end

-- Append our own update function to PlayerInputComponent.update
-- This runs after all other appended functions including EnhancedLivestock_PlayerInputComponent
function DewarNitrogenRefill.onPlayerInputUpdate(playerInputComponent)

	-- Reset target
	DewarNitrogenRefill.Target = nil

	if playerInputComponent.player == nil or not playerInputComponent.player.isOwner then
		DewarNitrogenRefill.UpdateActionEvents()
		return
	end

	if g_inputBinding:getContextName() ~= PlayerInputComponent.INPUT_CONTEXT_NAME then
		DewarNitrogenRefill.UpdateActionEvents()
		return
	end

	-- Use the same targeting approach as straw detection
	local closestNode = playerInputComponent.player.targeter:getClosestTargetedNodeFromType(PlayerInputComponent)

	if closestNode ~= nil then
		local object = g_currentMission:getNodeObject(closestNode)

		if object ~= nil and type(object.isa) == "function" and object:isa(Dewar) then
			-- Check if nitrogen needs refilling (independent of straws check)
			if object.nitrogenLevel ~= nil and object.nitrogenCapacity ~= nil and object.nitrogenLevel < object.nitrogenCapacity then
				DewarNitrogenRefill.Target = object
			end
		end
	end

	DewarNitrogenRefill.UpdateActionEvents()

end

PlayerInputComponent.update = Utils.appendedFunction(PlayerInputComponent.update, DewarNitrogenRefill.onPlayerInputUpdate)
