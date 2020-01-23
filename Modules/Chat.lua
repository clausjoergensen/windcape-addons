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

function Windcape:Chat_EnableURLCopy()
	local gsub = string.gsub
	local one = "|cffffffff|Hgarrmission:BCMuc:|h[%1]|h|r"
	local two = "%1|cffffffff|Hgarrmission:BCMuc:|h[%2]|h|r"

	-- This functionality used to be stricter and more complex, but with the introduction
	-- of gTLDs of any form or language, we can now reduce the amount of patterns.

	-- Sentences like "I wish.For someone" will become URLs now "[wish.For]", and although they seem
	-- like false positives, they can be genuine.

	-- Easily readable, right? :D
	-- We're converting anything in the form of "word.word" to a URL,
	-- but we're adding a list of excluded symbols such as {}[]` that aren't a valid address, to prevent possible false positives.
	-- Also note that the only difference between the 1st and 2nd section of the pattern is that the 2nd has a few extra
	-- valid (but invalid in their location) things ".", "/", "," to prevent words like "lol...", "true./" and "yes.," becoming a URL.
	-- As of the introduction of the S.E.L.F.I.E camera we now require at least 2 valid letters for example: yo.hi
	local filterFunc = function(_, _, msg, ...)
		-- [ ]url://a.b.cc.dd/e
		local newMsg, found = string.gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.b.cc.dd/e
		newMsg, found = string.gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		-- [ ]url://a.bb.cc/d
		newMsg, found = string.gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.bb.cc/d
		newMsg, found = string.gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		-- [ ]url://aa.bb/c
		newMsg, found = string.gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://aa.bb/c
		newMsg, found = string.gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+/[^ \"%^`{}%[%]\\|<>]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		-- [ ]url://a.b.cc.dd
		newMsg, found = string.gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.b.cc.dd
		newMsg, found = string.gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+",
			one
		)
		-- [ ]url://a.bb.cc
		newMsg, found = string.gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://a.bb.cc
		newMsg, found = string.gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+%.[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+",
			one
		)
		-- [ ]url://aa.bb
		newMsg, found = string.gsub(msg,
			"( )([^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+)",
			two
		)
		if found > 0 then return false, newMsg, ... end
		-- ^url://aa.bb
		newMsg, found = string.gsub(msg,
			"^[^ %%'=%.,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~]+[^ %%'=%./,\"%^`{}%[%]\\|<>%(%)%*!%?_%+#&;~:]%.[^ %p%c%d][^ %p%c%d]+",
			one
		)
		if found > 0 then return false, newMsg, ... end
		newMsg, found = string.gsub(msg,
			-- Numbers are banned from the first pattern to prevent false positives like "5.5k" etc.
			-- This is our IPv4/v6 pattern at the beggining of a sentence.
			"^%x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"%^`{}%[%]\\|<>]*",
			one
		)
		
		if found > 0 then return false, newMsg, ... end
		newMsg, found = string.gsub(msg,
			-- This is our mid-sentence IPv4/v6 pattern, we separate the IP patterns into 2 to prevent
			-- false positives with linking items, spells, etc.
			"( )(%x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"%^`{}%[%]\\|<>]*)",
			two
		)
		if found > 0 then return false, newMsg, ... end
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", filterFunc)

	hooksecurefunc("SetItemRef", function(link, text)
		local _, bcm = strsplit(":", link)
		if bcm == "BCMuc" then
			text = gsub(text, "^[^%[]+%[(.+)%]|h|r$", "%1")
			BCM:Popup(text)
		end
	end)
end







