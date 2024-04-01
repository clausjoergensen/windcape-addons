-- Copyright (c) 2023 Claus Jørgensen

Windcape_Quests = Windcape:NewModule("Quests", "AceEvent-3.0", "AceHook-3.0")

function Windcape_Quests:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Quests:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Quests:PLAYER_ENTERING_WORLD()
    QuestLogFrame:HookScript("OnShow", function (event, ...)
        for i = 1, 25 do
            local button = _G["QuestLogListScrollFrameButton" .. i]
            if button and button:GetNormalTexture():GetTexture() ~= 130821 then
                button:Click()
            end
        end
    end)

    hooksecurefunc(WatchFrame, "SetPoint", function(self)
        if setting then
            return
        end
        setting = true
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 30, -20)
        self:SetHeight(600)
        setting = nil
    end)
end
