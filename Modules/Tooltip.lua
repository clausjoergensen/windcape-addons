-- Copyright (c) 2023 Claus Jørgensen

Windcape_Tooltip = Windcape:NewModule("Tooltip", "AceEvent-3.0", "AceHook-3.0")

function Windcape_Tooltip:OnEnable()
    self:HookScript(GameTooltip, "OnTooltipSetUnit")
    self:HookScript(GameTooltip, "OnTooltipSetItem")
end

function Windcape_Tooltip:OnDisable()
    self:Unhook(GameTooltip, "OnTooltipSetUnit")
    self:Unhook(GameTooltip, "OnTooltipSetItem")
end

function Windcape_Tooltip:OnTooltipSetUnit(tooltip)
    GameTooltipStatusBar:Hide() -- Hide health bar

    tooltip:ClearAllPoints()
    tooltip:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", -10, 10)
end

function Windcape_Tooltip:OnTooltipSetItem(tooltip)
    local _, itemLink = tooltip:GetItem()
    if not item then
        return
    end

    local itemLevel = select(4, GetItemInfo(itemLink))
    if itemLevel then
        tooltip:AddLine("Item Level " .. itemLevel)
    end

    tooltip:Show()
end
