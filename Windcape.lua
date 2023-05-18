-- Copyright (c) 2021 Claus Jørgensen

Windcape = LibStub("AceAddon-3.0"):NewAddon("Windcape", 
    "AceConsole-3.0", 
    "AceHook-3.0", 
    "AceEvent-3.0", 
    "AceComm-3.0", 
    "AceSerializer-3.0"
)

Windcape:SetDefaultModuleState(true)

function Windcape:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("WindcapeDB", {
        char = { }
    }, true)
end

Windcape_Frame = CreateFrame("Frame", "Windcape_Player", UIParent)
Windcape_Frame:SetScript("OnEvent", function(self, event, ...)
    if event ~= "PLAYER_ENTERING_WORLD" then
        return
    end
    SetCVar("cameraDistanceMaxZoomFactor", 4)
    SetCVar("nameplateMaxDistance ", 41)
end)
Windcape_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
