-- Copyright (c) 2023 Claus Jørgensen

AutoInvite = Windcape:NewModule("AutoInvite", "AceEvent-3.0")

local function ON_CHAT_MSG_WHISPER(self, event, message, sender)
    if (strtrim(message):lower() == "inv") or (strtrim(message):lower() == "invite") then
        InviteUnit(sender)
    end
    return false
end

function AutoInvite:OnEnable()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ON_CHAT_MSG_WHISPER)
end

function AutoInvite:OnDisable()
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", ON_CHAT_MSG_WHISPER)
end