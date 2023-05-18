-- Copyright (c) 2023 Claus Jørgensen

Windcape_Mail = Windcape:NewModule("Mail", "AceEvent-3.0")

local MinimapMailText = MiniMapMailFrame:CreateFontString(nil, "ARTWORK")

function Windcape_Mail:OnEnable()
    MinimapMailText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    MinimapMailText:SetPoint("CENTER", 0, 0)
    MinimapMailText:SetText("M")

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Mail:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Mail:PLAYER_ENTERING_WORLD()
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("BOTTOMRIGHT", "Minimap", "BOTTOMRIGHT", 6, -8) -- Designed to work with BasicMinimap (Square)
    
    MiniMapMailBorder:Hide()
    MiniMapMailIcon:Hide()
end
