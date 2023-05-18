-- Copyright (c) 2023 Claus Jørgensen

Windcape_Camera = Windcape:NewModule("Camera", "AceEvent-3.0")

function Windcape_Camera:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Camera:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Camera:PLAYER_ENTERING_WORLD()
    SetCVar("cameraDistanceMaxZoomFactor", 4)
    SetCVar("nameplateMaxDistance ", 41)
end
