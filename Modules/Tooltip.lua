-- Copyright (c) 2023 Claus Jørgensen

Tooltip = Windcape:NewModule("Tooltip", "AceEvent-3.0", "AceHook-3.0")

function Tooltip:OnEnable()
    GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
        GameTooltipStatusBar:Hide() -- Hide health bar
        
        tooltip:ClearAllPoints()
        tooltip:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", -10, 10)
    end)

    GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
        local item = tooltip:GetItem()
        if not item then
            return
        end

        local _, _, _, itemLevel = GetItemInfo(item)
        
        if not itemLevel then
            return
        end 

        tooltip:AddLine("Item Level "..itemLevel) 
        tooltip:Show()
    end)
end

function Tooltip:OnDisable()
    GameTooltip:Unhook("OnTooltipSetItem")
end
