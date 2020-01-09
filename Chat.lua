-- Copyright (c) 2020 Claus Jørgensen

local showingTooltip = false
local linkTypes = {
    item = true,
    enchant = true,
    spell = true,
    quest = true,
    achievement = true,
    currency = true
}

function Windcape:Chat_OnEnable()
	self:ChatFrame_UpdateLayout()
	self:ChatFrame_EnableClassColors()
    self:ChatFrame_EnableHoverTips()
end

function Windcape:ChatFrame_OnDisable()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        self:Unhook(chatFrame, "OnHyperlinkEnter")
        self:Unhook(chatFrame, "OnHyperlinkLeave")
    end
end

function Windcape:ChatFrame_EnableClassColors()
	SetCVar("chatClassColorOverride", "0")
end

function Windcape:ChatFrame_UpdateLayout()
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

function Windcape:ChatFrame_EnableHoverTips()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        self:HookScript(chatFrame, "OnHyperlinkEnter", "ChatFrame_OnHyperlinkEnter")
        self:HookScript(chatFrame, "OnHyperlinkLeave", "ChatFrame_OnHyperlinkLeave")
    end
end

function Windcape:ChatFrame_OnHyperlinkEnter(frame, link)
    local linkType = string.match(link, "^(.-):")
    if linkTypes[linkType] then
        showingTooltip = true
        
        ShowUIPanel(GameTooltip)
        
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
        GameTooltip:SetHyperlink(link)
        GameTooltip:Show()
    end
end

function Windcape:ChatFrame_OnHyperlinkLeave(frame, link)
    if showingTooltip then
        showingTooltip = false
        GameTooltip:Hide()
    end
end
