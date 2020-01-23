-- Copyright (c) 2020 Claus Jørgensen

local COMBAT_LOG_FRAME_INDEX = 2
local showingTooltip = false

function Windcape:Chat_OnEnable()
	self:Chat_UpdateLayout()
	self:Chat_EnableClassColors()
	self:Chat_EnableHoverTips()
	self:Chat_EnableHistory()
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

function Windcape:Chat_EnableHistory()
	self:RegisterEvent("PLAYER_LOGOUT", "Chat_OnPlayerLogout")
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
	if not self.db.char.scrollback then
		return
	end

	local now = GetTime()

	for frameName, history in next, self.db.char.scrollback do
		local chatFrame = _G[frameName]
		if chatFrame then
			local historyBuffer = chatFrame.historyBuffer
			local restored = { }
			
			for i = 1, #history do
				local tbl = history[i]
				tbl.timestamp = now
				restored[#restored + 1] = tbl
			end

			for i = 1, historyBuffer.headIndex do
				local element = historyBuffer.elements[i]
				if element then
					element.timestamp = now
					restored[#restored + 1] = element
				end
			end

			historyBuffer.headIndex = #restored
			for i = 1, #restored do
				historyBuffer.elements[i] = restored[i]
			end
		end
	end
end

function Windcape:Chat_OnPlayerLogout()
	for i = 1, NUM_CHAT_WINDOWS do
		if i ~= COMBAT_LOG_FRAME_INDEX then
			local chatFrame = _G["ChatFrame" .. i]
			local historyBuffer = chatFrame.historyBuffer
			local historyTable = { 1, 2, 3, 4, 5 }
			
			local t = #historyTable
			for e = historyBuffer.headIndex, -10, -1 do
				if e > 0 then
					if t > 0 and type(historyBuffer.elements[e]) == "table" and historyBuffer.elements[e].message then
						historyTable[t] = historyBuffer.elements[e]
						t = t - 1
					end
				else
					if t > 0 then
						tremove(historyTable, t)
						t = t - 1
					end
				end
			end
			
			if #historyTable > 0 then
				self.db.char.scrollback[chatFrame:GetName()] = historyTable
			end
		end
	end
end
