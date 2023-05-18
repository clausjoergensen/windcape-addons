-- Copyright (c) 2023 Claus Jørgensen

Quests = Windcape:NewModule("Quests", "AceEvent-3.0", "AceHook-3.0")

function Quests:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function Quests:OnDisable()
    self:unregisterEvent("PLAYER_ENTERING_WORLD")
end

function Quests:PLAYER_ENTERING_WORLD() 
    hooksecurefunc(WatchFrame, "SetPoint", function(self)
        if not setting then
            setting = true
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 20, -20)
            self:SetHeight(600)
            setting = nil
        end
    end)
end