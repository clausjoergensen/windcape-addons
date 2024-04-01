-- Copyright (c) 2023 Claus Jørgensen

Windcape_Chat = Windcape:NewModule("Chat", "AceEvent-3.0", "AceHook-3.0")

local COMBAT_LOG_FRAME_INDEX = 2
local CHAT_HISTORY_MAX_LENGTH = 10

function Windcape_Chat:OnEnable()
    self:UpdateLayout()
    self:EnableClassColors()
    self:EnableHoverTips()
end

function Windcape_Chat:OnDisable()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        self:Unhook(chatFrame, "OnHyperlinkEnter")
        self:Unhook(chatFrame, "OnHyperlinkLeave")
    end
end

function Windcape_Chat:EnableClassColors()
    SetCVar("chatClassColorOverride", "0")
end

function Windcape_Chat:UpdateLayout()
    local FONT_SIZE = 12

    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        chatFrame:SetFont(_G.STANDARD_TEXT_FONT, FONT_SIZE, "")
        chatFrame:SetClampedToScreen(false)

        _G[chatFrame:GetName() .. "EditBoxLeft"]:Hide()
        _G[chatFrame:GetName() .. "EditBoxRight"]:Hide()
        _G[chatFrame:GetName() .. "EditBoxMid"]:Hide()

        local chatEditBoxFrame = _G[chatFrame:GetName() .. "EditBox"]
        chatEditBoxFrame:SetFont(_G.STANDARD_TEXT_FONT, FONT_SIZE, "")
        chatEditBoxFrame["SetAltArrowKeyMode"](chatEditBoxFrame, false)
        chatEditBoxFrame:ClearAllPoints()
        chatEditBoxFrame:SetPoint('BOTTOMLEFT',  chatFrame:GetName(), 'TOPLEFT',  -5, 0)
        chatEditBoxFrame:SetPoint('BOTTOMRIGHT', chatFrame:GetName(), 'TOPRIGHT', 5, 0)

        local chatEditBoxHeaderFrame = _G[chatEditBoxFrame:GetName() .. "Header"]
        chatEditBoxHeaderFrame:SetFont("Fonts\\FRIZQT__.TTF", FONT_SIZE, "")
    end
end

function Windcape_Chat:EnableHoverTips()
    self.showingTooltip = false

    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        self:HookScript(chatFrame, "OnHyperlinkEnter")
        self:HookScript(chatFrame, "OnHyperlinkLeave")
    end
end

function Windcape_Chat:OnHyperlinkEnter(frame, link)
    local linkType = string.match(link, "^(.-):")
    local linkTypes = {
        item = true,
        enchant = true,
        spell = true,
        quest = true,
        achievement = true,
        currency = true
    }

    if not linkTypes[linkType] then
        return
    end

    self.showingTooltip = true
    ShowUIPanel(GameTooltip)

    GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
    GameTooltip:SetHyperlink(link)
    GameTooltip:Show()
end

function Windcape_Chat:OnHyperlinkLeave(frame, link)
    if not self.showingTooltip then
        return
    end
    self.showingTooltip = false
    GameTooltip:Hide()
end
