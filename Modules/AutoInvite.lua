-- Copyright (c) 2023 Claus Jørgensen

function ON_CHAT_MSG_WHISPER(self, event, message, sender)
    if strtrim(message):lower() == "inv" then
        InviteUnit(sender)
    end
end

function Windcape:AutoInvite_OnEnable()
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ON_CHAT_MSG_WHISPER)
end

function Windcape:AutoInvite_OnDisable()
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", ON_CHAT_MSG_WHISPER)
end