EL_RenderElement = {}

local modDirectory = g_currentModDirectory


function EL_RenderElement:setScene(superFunc, filename)

	if filename == "animals/domesticated/earTagScene.i3d" then
        self.isEnhancedLivestockAsset = true
        filename = modDirectory .. filename
    end

	superFunc(self, filename)

end

RenderElement.setScene = Utils.overwrittenFunction(RenderElement.setScene, EL_RenderElement.setScene)


function EL_RenderElement:onSceneLoaded(node, failedReason, _)

    if failedReason == LoadI3DFailedReason.NONE and self.isEnhancedLivestockAsset then setVisibility(node, true) end

end

RenderElement.onSceneLoaded = Utils.appendedFunction(RenderElement.onSceneLoaded, EL_RenderElement.onSceneLoaded)