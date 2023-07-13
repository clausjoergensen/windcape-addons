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
