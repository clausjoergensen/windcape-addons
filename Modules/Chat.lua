-- Copyright (c) 2020 Claus Jørgensen

local showingTooltip = false

function Windcape:Chat_OnEnable()
	-- self:SecureHook("ChatFrame_MessageEventHandler")

	local filter = function(frame, event, message, ...)
		local frameName = frame:GetName()
		self.db.char.scrollback[frameName] = self.db.char.scrollback[frameName] or {}
		
		local scrollback = self.db.char.scrollback[frameName]
		table.insert(scrollback, { message, ... })

		self.db.char.scrollbackTime = time()
		if #scrollback > self.db.char.scrollbackLength then
			table.remove(scrollback, 1)
		end

		-- To leave the message untouched, return false or nil.
		-- You don't need to explicitly do this, so the
		-- "else return false" in this example is not required.
		return false
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)

	self:Chat_UpdateLayout()
	self:Chat_EnableClassColors()
	self:Chat_EnableHoverTips()
	self:Chat_RestoreLastSession()
end

function Windcape:Chat_OnDisable()
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame" .. i]
		self:Unhook(chatFrame, "OnHyperlinkEnter")
		self:Unhook(chatFrame, "OnHyperlinkLeave")
		self:Unhook(chatFrame, "OnEvent")
	end
end

function Windcape:Chat_EnableClassColors()
	SetCVar("chatClassColorOverride", "0")
end

function Windcape:Chat_UpdateLayout()
	local FONT_SIZE = 14
	
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame" .. i]
		chatFrame:SetFont(_G.STANDARD_TEXT_FONT, FONT_SIZE, nil)
		chatFrame:SetClampedToScreen(false)

		_G[chatFrame:GetName() .. "EditBoxLeft"]:Hide()
		_G[chatFrame:GetName() .. "EditBoxRight"]:Hide()
		_G[chatFrame:GetName() .. "EditBoxMid"]:Hide()

		local chatEditBoxFrame = _G[chatFrame:GetName() .. "EditBox"]
		chatEditBoxFrame:SetFont(_G.STANDARD_TEXT_FONT, FONT_SIZE, nil)
		chatEditBoxFrame["SetAltArrowKeyMode"](chatEditBoxFrame, false)
		chatEditBoxFrame:ClearAllPoints()
		chatEditBoxFrame:SetPoint('BOTTOMLEFT',  chatFrame:GetName(), 'TOPLEFT',  -5, 0)
		chatEditBoxFrame:SetPoint('BOTTOMRIGHT', chatFrame:GetName(), 'TOPRIGHT', 5, 0)

		local chatEditBoxHeaderFrame = _G[chatEditBoxFrame:GetName() .. "Header"]
		chatEditBoxHeaderFrame:SetFont("Fonts\\FRIZQT__.TTF", FONT_SIZE, nil)
	end
end

function Windcape:Chat_EnableHoverTips()
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame" .. i]

		self:HookScript(chatFrame, "OnHyperlinkEnter", function(frame, link)
			local linkType = string.match(link, "^(.-):")
			local linkTypes = {
				item = true,
				enchant = true,
				spell = true,
				quest = true,
				achievement = true,
				currency = true
			}

			if linkTypes[linkType] then
				showingTooltip = true
				
				ShowUIPanel(GameTooltip)
				
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
				GameTooltip:SetHyperlink(link)
				GameTooltip:Show()
			end
		end)
		
		self:HookScript(chatFrame, "OnHyperlinkLeave", function(frame, link)
			if showingTooltip then
				showingTooltip = false
				GameTooltip:Hide()
			end
		end)
	end
end

function Windcape:Chat_RestoreLastSession()
	local textAdded = false
	print(pairs(self.db.char.scrollback))
	for key, history in pairs(self.db.char.scrollback) do
		local frame = _G[key]
		print(frame)
		if frame then
			for _, line in ipairs(history) do
				frame:AddMessage(unpack(line))
				textAdded = true
			end

			if textAdded then
				frame:AddMessage(format(TIME_DAYHOURMINUTESECOND,
								 ChatFrame_TimeBreakDown(time() - self.db.char.scrollbackTime)))
			end
		end
	end
end

-- function Windcape:ChatFrame_OnChatMessage(info, message, frame, event, text, r, g, b, id, ...)
-- 	local frameName = frame:GetName()
-- 	self.scrollback[frameName] = self.scrollback[frameName] or {}
	
-- 	local scrollback = self.scrollback[frameName]
-- 	table.insert(scrollback, { text, r, g, b, id, ... })

-- 	self.db.char.scrollbackTime = time()
-- 	if #scrollback > self.db.profile.scrollbackLength then
-- 		table.remove(scrollback, 1)
-- 	end
-- end

-- function Windcape:ChatFrame_MessageEventHandler(event, ...)
-- 	if (strsub(event, 1, 8) == "CHAT_MSG") then
-- 		self:ChatFrame_OnChatMessage(...)
-- 	end
-- end
