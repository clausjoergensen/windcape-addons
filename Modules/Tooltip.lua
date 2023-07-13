-- Copyright (c) 2023 Claus Jørgensen

Windcape_Tooltip = Windcape:NewModule("Tooltip", "AceEvent-3.0", "AceHook-3.0")

function Windcape_Tooltip:OnEnable()
    self:HookScript(GameTooltip, "OnTooltipSetUnit")
    self:HookScript(GameTooltip, "OnTooltipSetItem")
end

function Windcape_Tooltip:OnDisable()
    GameTooltip:Unhook("OnTooltipSetItem")
end

function Windcape_Tooltip:OnTooltipSetUnit(tooltip)
    GameTooltipStatusBar:Hide() -- Hide health bar
        
    tooltip:ClearAllPoints()
    tooltip:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", -10, 10)
end

function Windcape_Tooltip:OnTooltipSetItem(tooltip)
    local item = tooltip:GetItem()
    if not item then
        return
    end

    local _, _, _, itemLevel = GetItemInfo(item)        
    if itemLevel then
        tooltip:AddLine("Item Level " .. itemLevel) 
    end

    tooltip:Show()
end
