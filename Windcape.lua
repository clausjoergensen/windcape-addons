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

    local LSM = LibStub("LibSharedMedia-3.0")

    -- Mage spell overlays
    LSM:Register(LSM.MediaType.BACKGROUND, "arcane_missiles_3", [[Interface\Addons\Windcape\Textures\Mage\arcane_missiles_3.blp]])
    LSM:Register(LSM.MediaType.BACKGROUND, "hot_streak", [[Interface\Addons\Windcape\Textures\Mage\hot_streak.blp]])

    -- Druid spell overlays
    LSM:Register(LSM.MediaType.BACKGROUND, "eclipse_moon", [[Interface\Addons\Windcape\Textures\Druid\eclipse_moon.blp]])
    LSM:Register(LSM.MediaType.BACKGROUND, "eclipse_sun", [[Interface\Addons\Windcape\Textures\Druid\eclipse_sun.blp]])
end
