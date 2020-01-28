-- Copyright (c) 2020 Claus Jørgensen

SLASH_SFX1 = "/sfx"

function SlashCmdList.SFX(command)
	SetCVar("Sound_EnableSFX", command)
end
