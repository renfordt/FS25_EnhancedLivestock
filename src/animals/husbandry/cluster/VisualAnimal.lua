VisualAnimal = {}

-- FontLibrary detection (checked lazily since g_modIsLoaded may not be populated at script load time)
VisualAnimal.useFontLibrary = nil

-- Ear tag text rendering (default enabled)
VisualAnimal.earTagTextEnabled = true

function VisualAnimal.isFontLibraryAvailable()
	if VisualAnimal.useFontLibrary == nil then
		-- Check if FS25_FontLibrary mod is loaded and functions are available
		VisualAnimal.useFontLibrary = g_modIsLoaded ~= nil and g_modIsLoaded["FS25_FontLibrary"] == true and create3DLinkedText ~= nil
	end
	return VisualAnimal.useFontLibrary
end

function VisualAnimal.onSettingChanged(name, value)
	if name == "earTagTextEnabled" then
		VisualAnimal.earTagTextEnabled = value
		-- Refresh all existing visual animals
		VisualAnimal.refreshAllEarTags()
	end
end

function VisualAnimal.refreshAllEarTags()
	if g_currentMission == nil or g_currentMission.husbandrySystem == nil then return end

	for _, placeable in pairs(g_currentMission.husbandrySystem.placeables) do
		local animals = placeable:getClusters()
		for _, animal in pairs(animals) do
			if animal.visualAnimal ~= nil then
				animal.visualAnimal:setLeftEarTag()
				animal.visualAnimal:setRightEarTag()
			end
		end
	end
end

local VisualAnimal_mt = Class(VisualAnimal)


function VisualAnimal.new(animal, husbandryId, animalId)

	local self = setmetatable({}, VisualAnimal_mt)

	self.animal = animal
	self.husbandryId = husbandryId
	self.animalId = animalId

	self.nodes = {
		["root"] = getAnimalRootNode(husbandryId, animalId)
	}
	self.texts = {
		["earTagLeft"] = {},
		["earTagRight"] = {}
	}

	self.leftTextColour, self.rightTextColour = { 0, 0, 0 }, { 0, 0, 0 }

	return self

end

function VisualAnimal:load()

	local nodes = self.nodes
	local visualData = g_currentMission.animalSystem:getVisualByAge(self.animal.subTypeIndex, self.animal.age)

	if visualData.monitor ~= nil then nodes.monitor = I3DUtil.indexToObject(nodes.root, visualData.monitor) end
	if visualData.noseRing ~= nil then nodes.noseRing = I3DUtil.indexToObject(nodes.root, visualData.noseRing) end
	if visualData.bumId ~= nil then nodes.bumId = I3DUtil.indexToObject(nodes.root, visualData.bumId) end
	if visualData.marker ~= nil then nodes.marker = I3DUtil.indexToObject(nodes.root, visualData.marker) end
	if visualData.earTagLeft ~= nil then nodes.earTagLeft = I3DUtil.indexToObject(nodes.root, visualData.earTagLeft) end
	if visualData.earTagRight ~= nil then nodes.earTagRight = I3DUtil.indexToObject(nodes.root, visualData.earTagRight) end

	self:setMonitor()
	self:setNoseRing()
	self:setBumId()
	self:setMarker()
	self:setLeftEarTag()
	self:setRightEarTag()

end


function VisualAnimal:setMonitor()

	if self.nodes.monitor == nil then return end

    setVisibility(self.nodes.monitor, self.animal.monitor.active or self.animal.monitor.removed)

end


function VisualAnimal:setNoseRing()

	if self.nodes.noseRing == nil then return end

    setVisibility(self.nodes.noseRing, self.animal.gender == "male")

end


function VisualAnimal:setBumId()

	if self.nodes.bumId == nil then return end

	local uniqueId = self.animal.uniqueId
	local node = self.nodes.bumId

	if VisualAnimal.isFontLibraryAvailable() then
		-- FontLibrary approach
		if self.texts.bumId ~= nil then
			for _, nodes in pairs(self.texts.bumId) do
				for _, textNode in pairs(nodes) do delete3DLinkedText(textNode) end
			end
		end

		self.texts.bumId = {
			["uniqueId"] = {
				["top"] = create3DLinkedText(node, 0, -0.006, 0, 0, 0, 0, 0.05, string.sub(uniqueId, 3, 4)),
				["bottom"] = create3DLinkedText(node, 0, -0.012, 0, 0, 0, 0, 0.05, string.sub(uniqueId, 5, 6))
			}
		}
	else
		-- Shader-based fallback (no FontLibrary)
		local numCharacters = EnhancedLivestock.NUM_CHARACTERS

		-- Partial animal ID (last 4 digits, positions 3-6)
		for bumIdIndex = 1, 4 do
			local characterIndex = tonumber(string.sub(uniqueId, bumIdIndex + 2, bumIdIndex + 2))
			local bumNode = getChild(node, "bumId" .. bumIdIndex)

			if bumNode ~= nil and bumNode ~= 0 then
				setShaderParameter(bumNode, "playScale", characterIndex, 0, numCharacters, 1, false)
			end
		end
	end

end


function VisualAnimal:setMarker()

	if self.nodes.marker == nil then return end

	local markerColour = AnimalSystem.BREED_TO_MARKER_COLOUR[self.animal.breed]
    local isMarked = self.animal:getMarked()

    setVisibility(self.nodes.marker, isMarked)
    if isMarked then setShaderParameter(self.nodes.marker, "colorScale", markerColour[1], markerColour[2], markerColour[3], nil, false) end

end



function VisualAnimal:setEarTagColours(leftTag, leftText, rightTag, rightText)

	if self.nodes.earTagLeft ~= nil then

		if leftTag ~= nil then setShaderParameter(self.nodes.earTagLeft, "colorScale", leftTag[1], leftTag[2], leftTag[3], nil, false) end

		if leftText ~= nil then
			self.leftTextColour = leftText

			if VisualAnimal.isFontLibraryAvailable() then
				-- FontLibrary approach - update text colours directly
				for _, nodes in pairs(self.texts.earTagLeft) do
					for _, textNode in pairs(nodes) do change3DLinkedTextColour(textNode, leftText[1], leftText[2], leftText[3], 1) end
				end
			else
				-- Shader-based fallback - update all child nodes' colorScale
				local node = self.nodes.earTagLeft
				for colourI = 0, getNumOfChildren(node) - 1 do
					local colourChild = getChildAt(node, colourI)
					if getHasClassId(colourChild, ClassIds.SHAPE) then
						setShaderParameter(colourChild, "colorScale", leftText[1], leftText[2], leftText[3], nil, false)
					end
				end
			end
		end

	end

	if self.nodes.earTagRight ~= nil then

		if rightTag ~= nil then setShaderParameter(self.nodes.earTagRight, "colorScale", rightTag[1], rightTag[2], rightTag[3], nil, false) end

		if rightText ~= nil then
			self.rightTextColour = rightText

			if VisualAnimal.isFontLibraryAvailable() then
				-- FontLibrary approach - update text colours directly
				for _, nodes in pairs(self.texts.earTagRight) do
					for _, textNode in pairs(nodes) do change3DLinkedTextColour(textNode, rightText[1], rightText[2], rightText[3], 1) end
				end
			else
				-- Shader-based fallback - update all child nodes' colorScale
				local node = self.nodes.earTagRight
				for colourI = 0, getNumOfChildren(node) - 1 do
					local colourChild = getChildAt(node, colourI)
					if getHasClassId(colourChild, ClassIds.SHAPE) then
						setShaderParameter(colourChild, "colorScale", rightText[1], rightText[2], rightText[3], nil, false)
					end
				end
			end
		end

	end

end


function VisualAnimal:setLeftEarTag()

	if self.nodes.earTagLeft == nil then return end

	local node = self.nodes.earTagLeft

	-- If ear tag text is disabled, hide all text elements and return
	if not VisualAnimal.earTagTextEnabled then
		-- Delete any existing FontLibrary text
		for _, nodes in pairs(self.texts.earTagLeft) do
			for _, textNode in pairs(nodes) do
				if delete3DLinkedText ~= nil then delete3DLinkedText(textNode) end
			end
		end
		self.texts.earTagLeft = {}
		-- Hide all child nodes (both shader shapes and TransformGroups)
		for i = 0, getNumOfChildren(node) - 1 do
			setVisibility(getChildAt(node, i), false)
		end
		return
	end

	local uniqueId = self.animal.uniqueId
	local farmId = self.animal.farmId
	local birthday = self.animal:getBirthday()
	local countryCode
	if birthday ~= nil and birthday.country ~= nil and EnhancedLivestock.AREA_CODES[birthday.country] ~= nil then
		countryCode = EnhancedLivestock.AREA_CODES[birthday.country].code
	else
		countryCode = EnhancedLivestock.getMapCountryCode()
	end
	local colour = self.leftTextColour

	if VisualAnimal.isFontLibraryAvailable() then
		-- FontLibrary approach
		for _, nodes in pairs(self.texts.earTagLeft) do
			for _, textNode in pairs(nodes) do delete3DLinkedText(textNode) end
		end

		-- Hide shader-based character shapes (they show 0s otherwise)
		for i = 0, getNumOfChildren(node) - 1 do
			local child = getChildAt(node, i)
			if getHasClassId(child, ClassIds.SHAPE) then
				setVisibility(child, false)
			end
		end

		local front = getChild(node, "front")
		local back = getChild(node, "back")

		-- Ensure TransformGroups are visible (may have been hidden when setting was disabled)
		if front ~= nil and front ~= 0 then setVisibility(front, true) end
		if back ~= nil and back ~= 0 then setVisibility(back, true) end

		setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
		setTextAlignment(RenderText.ALIGN_CENTER)
		setTextColor(colour[1], colour[2], colour[3], 1)

		self.texts.earTagLeft = {
			["uniqueId"] = {
				["back"] = create3DLinkedText(back, 0, -0.006, -0.015, 0, 0, 0, 0.035, uniqueId),
				["front"] = create3DLinkedText(front, 0, -0.006, -0.015, 0, 0, 0, 0.035, uniqueId)
			},
			["farmId"] = {
				["back"] = create3DLinkedText(back, 0, -0.041, -0.02, 0, 0, 0, 0.05, farmId),
				["front"] = create3DLinkedText(front, 0, -0.041, -0.02, 0, 0, 0, 0.05, farmId)
			},
			["country"] = {
				["back"] = create3DLinkedText(back, 0, 0.021, -0.015, 0, 0, 0, 0.03, countryCode),
				["front"] = create3DLinkedText(front, 0, 0.021, -0.015, 0, 0, 0, 0.03, countryCode)
			}
		}

		setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
		setTextAlignment(RenderText.ALIGN_LEFT)
		setTextColor(1, 1, 1, 1)
	else
		-- Shader-based fallback (no FontLibrary)
		local numCharacters = EnhancedLivestock.NUM_CHARACTERS

		-- Set text colour and visibility on all children (only Shape nodes, skip TransformGroups like front/back)
		for colourI = 0, getNumOfChildren(node) - 1 do
			local colourChild = getChildAt(node, colourI)
			if getHasClassId(colourChild, ClassIds.SHAPE) then
				setVisibility(colourChild, true)
				setShaderParameter(colourChild, "colorScale", colour[1], colour[2], colour[3], nil, false)
			end
		end

		-- Animal unique ID (6 digits)
		for earTagIndex = 1, 6 do
			local characterIndex = tonumber(string.sub(uniqueId, earTagIndex, earTagIndex))

			local nodeFront = getChild(node, "animalIdFront_" .. earTagIndex)
			local nodeBack = getChild(node, "animalIdBack_" .. earTagIndex)

			if nodeFront ~= nil and nodeFront ~= 0 then
				setShaderParameter(nodeFront, "playScale", characterIndex, 0, numCharacters, 1, false)
			end
			if nodeBack ~= nil and nodeBack ~= 0 then
				setShaderParameter(nodeBack, "playScale", characterIndex, 0, numCharacters, 1, false)
			end
		end

		-- Farm ID (6 digits)
		for earTagIndex = 1, 6 do
			local characterIndex = tonumber(string.sub(farmId, earTagIndex, earTagIndex))

			local nodeFront = getChild(node, "farmIdFront_" .. earTagIndex)
			local nodeBack = getChild(node, "farmIdBack_" .. earTagIndex)

			if nodeFront ~= nil and nodeFront ~= 0 then
				setShaderParameter(nodeFront, "playScale", characterIndex, 0, numCharacters, 1, false)
			end
			if nodeBack ~= nil and nodeBack ~= 0 then
				setShaderParameter(nodeBack, "playScale", characterIndex, 0, numCharacters, 1, false)
			end
		end

		-- Country/Area code (2 characters)
		for earTagIndex = 1, 2 do
			local character = string.sub(countryCode, earTagIndex, earTagIndex)
			local characterIndex = EnhancedLivestock.ALPHABET[character:upper()]

			local nodeFront = getChild(node, "areaCodeFront_" .. earTagIndex)
			local nodeBack = getChild(node, "areaCodeBack_" .. earTagIndex)

			if nodeFront ~= nil and nodeFront ~= 0 then
				setShaderParameter(nodeFront, "playScale", characterIndex, 0, numCharacters, 1, false)
			end
			if nodeBack ~= nil and nodeBack ~= 0 then
				setShaderParameter(nodeBack, "playScale", characterIndex, 0, numCharacters, 1, false)
			end
		end
	end

end


function VisualAnimal:setRightEarTag()

	if self.nodes.earTagRight == nil then return end

	local node = self.nodes.earTagRight

	-- If ear tag text is disabled, hide all text elements and return
	if not VisualAnimal.earTagTextEnabled then
		-- Delete any existing FontLibrary text
		for _, nodes in pairs(self.texts.earTagRight) do
			for _, textNode in pairs(nodes) do
				if delete3DLinkedText ~= nil then delete3DLinkedText(textNode) end
			end
		end
		self.texts.earTagRight = {}
		-- Hide all child nodes (both shader shapes and TransformGroups)
		for i = 0, getNumOfChildren(node) - 1 do
			setVisibility(getChildAt(node, i), false)
		end
		return
	end

	local colour = self.rightTextColour
	local name = self.animal:getName()
	local birthday = self.animal:getBirthday()

	if birthday == nil then
		setVisibility(node, false)
		return
	end

	local day, month, year = birthday.day, birthday.month, birthday.year + EnhancedLivestock.START_YEAR.PARTIAL
	local birthdayText = string.format("%s%s/%s%s/%s%s", day < 10 and 0 or "", day, month < 10 and 0 or "", month, year < 10 and 0 or "", year)

	if VisualAnimal.isFontLibraryAvailable() then
		-- FontLibrary approach
		for _, nodes in pairs(self.texts.earTagRight) do
			for _, textNode in pairs(nodes) do delete3DLinkedText(textNode) end
		end

		-- Hide shader-based character shapes (they show 0s otherwise)
		for i = 0, getNumOfChildren(node) - 1 do
			local child = getChildAt(node, i)
			if getHasClassId(child, ClassIds.SHAPE) then
				setVisibility(child, false)
			end
		end

		local front = getChild(node, "front")
		local back = getChild(node, "back")

		-- Ensure TransformGroups are visible (may have been hidden when setting was disabled)
		if front ~= nil and front ~= 0 then setVisibility(front, true) end
		if back ~= nil and back ~= 0 then setVisibility(back, true) end

		set3DTextAutoScale(true)
		set3DTextRemoveSpaces(true)
		set3DTextWrapWidth(0.14)
		setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_MIDDLE)
		setTextAlignment(RenderText.ALIGN_CENTER)
		setTextColor(colour[1], colour[2], colour[3], 1)
		set3DTextWordsPerLine(1)
		setTextLineHeightScale(0.75)

		self.texts.earTagRight = {
			["name"] = {
				["back"] = create3DLinkedText(back, 0, -0.01, -0.015, 0, 0, 0, 0.035, name),
				["front"] = create3DLinkedText(front, 0, -0.01, -0.015, 0, 0, 0, 0.035, name)
			}
		}

		set3DTextWrapWidth(0)

		self.texts.earTagRight.birthday = {
			["back"] = create3DLinkedText(back, 0, 0.018, -0.015, 0, 0, 0, 0.02, birthdayText),
			["front"] = create3DLinkedText(front, 0, 0.018, -0.015, 0, 0, 0, 0.02, birthdayText)
		}

		setTextLineHeightScale(1.1)
		set3DTextWordsPerLine(0)
		set3DTextAutoScale(false)
		set3DTextRemoveSpaces(false)
		setTextVerticalAlignment(RenderText.VERTICAL_ALIGN_BASELINE)
		setTextAlignment(RenderText.ALIGN_LEFT)
		setTextColor(1, 1, 1, 1)
	else
		-- Shader-based fallback (no FontLibrary)
		local numCharacters = EnhancedLivestock.NUM_CHARACTERS

		-- Set text colour and visibility on all children (only Shape nodes, skip TransformGroups like front/back)
		for colourI = 0, getNumOfChildren(node) - 1 do
			local colourChild = getChildAt(node, colourI)
			if getHasClassId(colourChild, ClassIds.SHAPE) then
				setVisibility(colourChild, true)
				setShaderParameter(colourChild, "colorScale", colour[1], colour[2], colour[3], nil, false)
			end
		end

		if (name == "" or name == nil) and birthday == nil then
			setVisibility(node, false)
		else
			-- Birthday - DAY
			local day1FrontNode = getChild(node, "birthDayFront1")
			local day1BackNode = getChild(node, "birthDayBack1")
			local day2FrontNode = getChild(node, "birthDayFront2")
			local day2BackNode = getChild(node, "birthDayBack2")

			local dayStr = tostring(birthday.day)
			local day1CharacterIndex = tonumber(#dayStr == 1 and 0 or string.sub(dayStr, 1, 1))
			local day2CharacterIndex = tonumber(#dayStr == 1 and string.sub(dayStr, 1, 1) or string.sub(dayStr, 2, 2))

			if day1FrontNode ~= nil and day1FrontNode ~= 0 then setShaderParameter(day1FrontNode, "playScale", day1CharacterIndex, 0, numCharacters, 1, false) end
			if day1BackNode ~= nil and day1BackNode ~= 0 then setShaderParameter(day1BackNode, "playScale", day1CharacterIndex, 0, numCharacters, 1, false) end
			if day2FrontNode ~= nil and day2FrontNode ~= 0 then setShaderParameter(day2FrontNode, "playScale", day2CharacterIndex, 0, numCharacters, 1, false) end
			if day2BackNode ~= nil and day2BackNode ~= 0 then setShaderParameter(day2BackNode, "playScale", day2CharacterIndex, 0, numCharacters, 1, false) end

			-- Birthday - MONTH
			local month1FrontNode = getChild(node, "birthMonthFront1")
			local month1BackNode = getChild(node, "birthMonthBack1")
			local month2FrontNode = getChild(node, "birthMonthFront2")
			local month2BackNode = getChild(node, "birthMonthBack2")

			local monthStr = tostring(birthday.month)
			local month1CharacterIndex = tonumber(#monthStr == 1 and 0 or string.sub(monthStr, 1, 1))
			local month2CharacterIndex = tonumber(#monthStr == 1 and string.sub(monthStr, 1, 1) or string.sub(monthStr, 2, 2))

			if month1FrontNode ~= nil and month1FrontNode ~= 0 then setShaderParameter(month1FrontNode, "playScale", month1CharacterIndex, 0, numCharacters, 1, false) end
			if month1BackNode ~= nil and month1BackNode ~= 0 then setShaderParameter(month1BackNode, "playScale", month1CharacterIndex, 0, numCharacters, 1, false) end
			if month2FrontNode ~= nil and month2FrontNode ~= 0 then setShaderParameter(month2FrontNode, "playScale", month2CharacterIndex, 0, numCharacters, 1, false) end
			if month2BackNode ~= nil and month2BackNode ~= 0 then setShaderParameter(month2BackNode, "playScale", month2CharacterIndex, 0, numCharacters, 1, false) end

			-- Birthday - YEAR
			local year1FrontNode = getChild(node, "birthYearFront1")
			local year1BackNode = getChild(node, "birthYearBack1")
			local year2FrontNode = getChild(node, "birthYearFront2")
			local year2BackNode = getChild(node, "birthYearBack2")

			local yearStr = tostring(year)
			local year1CharacterIndex = tonumber(#yearStr == 1 and 0 or string.sub(yearStr, 1, 1))
			local year2CharacterIndex = tonumber(#yearStr == 1 and string.sub(yearStr, 1, 1) or string.sub(yearStr, 2, 2))

			if year1FrontNode ~= nil and year1FrontNode ~= 0 then setShaderParameter(year1FrontNode, "playScale", year1CharacterIndex, 0, numCharacters, 1, false) end
			if year1BackNode ~= nil and year1BackNode ~= 0 then setShaderParameter(year1BackNode, "playScale", year1CharacterIndex, 0, numCharacters, 1, false) end
			if year2FrontNode ~= nil and year2FrontNode ~= 0 then setShaderParameter(year2FrontNode, "playScale", year2CharacterIndex, 0, numCharacters, 1, false) end
			if year2BackNode ~= nil and year2BackNode ~= 0 then setShaderParameter(year2BackNode, "playScale", year2CharacterIndex, 0, numCharacters, 1, false) end

			-- Animal name
			local templateNodeFront = getChild(node, "animalNameFront")
			local templateNodeBack = getChild(node, "animalNameBack")

			if name ~= "" and name ~= nil and templateNodeFront ~= nil and templateNodeFront ~= 0 then
				local words = string.split(name, " ")

				local fnx, fny, fnz = getTranslation(templateNodeFront)
				local bnx, bny, bnz = getTranslation(templateNodeBack)

				local sx, sy, sz

				if #words == 1 then
					fny = fny - 0.012
					bny = bny - 0.012
				end

				local nodeNameCharacterIndex = 1

				for wordIndex = 1, #words do
					local word = words[wordIndex]
					local characterOffset = 0.054 / #word
					local characterScale = 0

					if #word > 6 then
						sx, sy, sz = getScale(templateNodeFront)
						characterScale = math.min((#word - 6) * 0.02, 0.2)
					end

					for charIndex = 1, #word do
						local character = string.sub(word, charIndex, charIndex)
						local characterIndex = EnhancedLivestock.ALPHABET[character:upper()]

						if wordIndex == 1 and charIndex == 1 then
							setTranslation(templateNodeFront, fnx, fny, fnz - characterScale * 0.05 + characterOffset)
							setTranslation(templateNodeBack, bnx, bny, bnz + characterScale * 0.05 - characterOffset)
							setShaderParameter(templateNodeFront, "playScale", characterIndex, 0, numCharacters, 1, false)
							setShaderParameter(templateNodeBack, "playScale", characterIndex, 0, numCharacters, 1, false)

							if characterScale > 0 then setScale(templateNodeFront, sx, sy - characterScale, sz - characterScale) end
							if characterScale > 0 then setScale(templateNodeBack, sx, sy - characterScale, sz - characterScale) end
						else
							local fnode = clone(templateNodeFront, true, false, false)
							local bnode = clone(templateNodeBack, true, false, false)

							setName(fnode, "animalNameFront_" .. nodeNameCharacterIndex)
							setName(bnode, "animalNameBack_" .. nodeNameCharacterIndex)

							nodeNameCharacterIndex = nodeNameCharacterIndex + 1

							if charIndex == 1 then
								templateNodeFront = fnode
								templateNodeBack = bnode
							end

							setTranslation(fnode, fnx, fny - (wordIndex > 1 and (characterScale * 0.05) or 0) - (wordIndex - 1) * 0.032, fnz + characterScale * 0.1 + characterOffset + (charIndex - 1) * 0.024)
							setTranslation(bnode, bnx, bny - (wordIndex > 1 and (characterScale * 0.05) or 0) - (wordIndex - 1) * 0.032, bnz - characterScale * 0.1 - characterOffset - (charIndex - 1) * 0.024)

							if characterScale > 0 then setScale(fnode, sx, sy - characterScale, sz - characterScale) end
							if characterScale > 0 then setScale(bnode, sx, sy - characterScale, sz - characterScale) end

							setShaderParameter(fnode, "playScale", characterIndex, 0, numCharacters, 1, false)
							setShaderParameter(bnode, "playScale", characterIndex, 0, numCharacters, 1, false)
						end
					end
				end
			elseif templateNodeFront ~= nil and templateNodeFront ~= 0 then
				setVisibility(templateNodeFront, false)
				if templateNodeBack ~= nil and templateNodeBack ~= 0 then
					setVisibility(templateNodeBack, false)
				end
			end
		end
	end

end