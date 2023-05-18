-- Copyright (c) 2021 Claus Jørgensen

Chat = Windcape:NewModule("Chat", "AceEvent-3.0", "AceHook-3.0")

local COMBAT_LOG_FRAME_INDEX = 2
local CHAT_HISTORY_MAX_LENGTH = 10
local showingTooltip = false

function Chat:OnEnable()
    self:UpdateLayout()
    self:EnableClassColors()
    self:EnableHoverTips()
end

function Chat:OnDisable()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        self:Unhook(chatFrame, "OnHyperlinkEnter")
        self:Unhook(chatFrame, "OnHyperlinkLeave")
        self:Unhook(chatFrame, "OnEvent")
    end
end

function Chat:EnableClassColors()
    SetCVar("chatClassColorOverride", "0")
end

function Chat:UpdateLayout()
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

function Chat:EnableHoverTips()
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
