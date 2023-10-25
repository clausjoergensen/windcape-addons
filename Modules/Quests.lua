-- Copyright (c) 2023 Claus Jørgensen

Windcape_Quests = Windcape:NewModule("Quests", "AceEvent-3.0", "AceHook-3.0")

function Windcape_Quests:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Quests:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Quests:PLAYER_ENTERING_WORLD()
    QuestLogFrame:HookScript("OnUpdate", function (event, ...)
        wasQuestLogVisible = isQuestLogVisible
        isQuestLogVisible = QuestLogFrame:IsVisible() 
        if isQuestLogVisible == wasQuestLogVisible then
            return
        end
        
        if not isQuestLogVisible then
            return
        end

        NUM_QUESTLOG_LIST_SCROLLFRAME_BUTTONS = 25
        
        for i = 1, NUM_QUESTLOG_LIST_SCROLLFRAME_BUTTONS do
            button = _G["QuestLogListScrollFrameButton" .. i]
            zoneText = GetZoneText()
            if button and button:GetText() ~= zoneText then -- Quests in the current zone are already expanded
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
        self:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 20, -20)
        self:SetHeight(600)
        setting = nil
    end)
end
