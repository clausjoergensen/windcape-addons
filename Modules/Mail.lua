-- Copyright (c) 2023 Claus Jørgensen

Mail = Windcape:NewModule("Mail", "AceEvent-3.0")

function Mail:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Mail:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Mail:PLAYER_ENTERING_WORLD()
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetPoint("BOTTOMRIGHT", "Minimap", "BOTTOMRIGHT", 6, -8) -- Designed to work with BasicMinimap (Square)
    
    MiniMapMailBorder:Hide()
    MiniMapMailIcon:Hide()

    local minimapText = MiniMapMailFrame:CreateFontString(nil, "ARTWORK")
    minimapText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    minimapText:SetPoint("CENTER", 0, 0)
    minimapText:SetText("M")
end
