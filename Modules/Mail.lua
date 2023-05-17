-- Copyright (c) 2023 Claus Jørgensen

function Windcape:Mail_OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Mail_PlayerEnteringWorld")
end

function Windcape:Mail_OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape:Mail_PlayerEnteringWorld()
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("BOTTOMRIGHT", "Minimap", "BOTTOMRIGHT", 6, -8) -- Designed to work with BasicMinimap (Square)
    
    MiniMapMailBorder:Hide()
    MiniMapMailIcon:Hide()

    local minimapText = MiniMapMailFrame:CreateFontString(nil, "ARTWORK")
    minimapText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    minimapText:SetPoint("CENTER", 0, 0)
    minimapText:SetText("M")
end