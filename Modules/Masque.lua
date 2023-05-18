-- Copyright (c) 2021 Claus Jørgensen

local MSQ = LibStub("Masque", true)

if not MSQ then return end

local AddOn, _ = ...
local Version = GetAddOnMetadata(AddOn, "Version")

MSQ:AddSkin("Windcape", {
	Author = "Windcape",
	Version = Version,
	Shape = "Circle",
	Masque_Version = 80000,
	Icon = {
		Width = 38,
		Height = 38,
		Mask = [[Interface\AddOns\Windcape\Textures\IconMask_Thick]],
		MaskWidth = 40,
		MaskHeight = 40,
	},
	Cooldown = {
		Width = 40,
		Height = 40,
		Color = {0, 0, 0, 0.6},
        Texture = [[Interface\AddOns\Windcape\Textures\IconMask_Thick]],
	},
	Normal = {
		Width = 40,
		Height = 40,
		Color = {0.85, 0.85, 0.85, 1},
		Texture = [[Interface\AddOns\Windcape\Textures\Normal_Thick]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		Color = {1, 1, 1, 0.3},
		Texture = [[Interface\AddOns\Windcape\Textures\Normal_Thick]],
	},
	Pushed = {
		Width = 40,
		Height = 40,
		Color = {0, 0, 0, 0.5},
		Texture = [[Interface\AddOns\Windcape\Textures\IconMask_Thick]],
	},
}, true)
