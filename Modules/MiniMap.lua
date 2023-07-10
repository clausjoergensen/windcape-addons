-- Copyright (c) 2023 Claus Jørgensen

Windcape_MiniMap = Windcape:NewModule("MiniMap", "AceEvent-3.0")

function Windcape_MiniMap:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_MiniMap:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_MiniMap:PLAYER_ENTERING_WORLD()
    MiniMapLFGFrame:ClearAllPoints()
    MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", "Minimap", "BOTTOMRIGHT", 6, -36)

    MiniMapBattlefieldFrame:ClearAllPoints()
    if MiniMapLFGFrame:IsShown() then
        MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", "MiniMapLFGFrame", "BOTTOMRIGHT", -34, -1)
    else
        MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", "Minimap", "BOTTOMRIGHT", 6, -37)
    end
end
