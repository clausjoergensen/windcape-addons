-- Copyright (c) 2020 Claus Jørgensen

Windcape = LibStub("AceAddon-3.0"):NewAddon("Windcape", 
	"AceConsole-3.0", 
	"AceHook-3.0", 
	"AceEvent-3.0", 
	"AceComm-3.0", 
	"AceSerializer-3.0"
)

function Windcape:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("WindcapeDB", {
		char = { 
			scrollback = { },
			scrollbackTime = 0,
			scrollbackLength = 50
		}
	}, true)
end

function Windcape:OnEnable()
	self:WorldMap_OnEnable()
	self:Chat_OnEnable()
end

function Windcape:OnDisable()
	self:WorldMap_OnDisable()
	self:Chat_OnDisable()
end
