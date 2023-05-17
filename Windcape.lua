-- Copyright (c) 2021 Claus Jørgensen

Windcape = LibStub("AceAddon-3.0"):NewAddon("Windcape", 
    "AceConsole-3.0", 
    "AceHook-3.0", 
    "AceEvent-3.0", 
    "AceComm-3.0", 
    "AceSerializer-3.0"
)

function Windcape:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("WindcapeDB", {
        char = { }
    }, true)
end

function Windcape:OnEnable()
    self:WorldMap_OnEnable()
    self:Chat_OnEnable()
    self:AutoRepair_OnEnable()
    self:Buffs_OnEnable()
    self:Tooltip_OnEnable()
    self:Quests_OnEnable()
    self:AutoInvite_OnEnable()
    self:Mail_OnEnable()
end

function Windcape:OnDisable()
    self:WorldMap_OnDisable()
    self:Chat_OnDisable()
    self:AutoRepair_OnDisable()
    self:Buffs_OnDisable()
    self:Tooltip_OnDisable()
    self:Quests_OnDisable()
    self:AutoInvite_OnDisable()
    self:Mail_OnDisable()
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
