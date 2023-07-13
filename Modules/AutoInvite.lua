-- Copyright (c) 2023 Claus Jørgensen

Windcape_AutoInvite = Windcape:NewModule("AutoInvite", "AceEvent-3.0")

local function ON_CHAT_MSG_WHISPER(self, event, message, sender)
    if not ((strtrim(message):lower() == "inv") or (strtrim(message):lower() == "invite")) then
        return
    end

    InviteUnit(sender)
end

function Windcape_AutoInvite:OnEnable()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ON_CHAT_MSG_WHISPER)
end

function Windcape_AutoInvite:OnDisable()
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", ON_CHAT_MSG_WHISPER)
end
