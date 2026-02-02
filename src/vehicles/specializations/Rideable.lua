EL_Rideable = {}

function EL_Rideable:onLoad(save)

	if save == nil then
		return
	end

	local animal = Animal.loadFromXMLFile(save.xmlFile, save.key .. ".rideable.animal")

	self:setCluster(animal)

end

Rideable.onLoad = Utils.appendedFunction(Rideable.onLoad, EL_Rideable.onLoad)