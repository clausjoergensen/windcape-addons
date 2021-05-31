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
end

function Windcape:OnDisable()
    self:WorldMap_OnDisable()
    self:Chat_OnDisable()
    self:AutoRepair_OnDisable()
    self:Buffs_OnDisable()
end
