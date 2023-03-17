-- Copyright (c) 2023 Claus Jørgensen

function Windcape:Quests_OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Quests_PlayerEnteringWorld")
end

function Windcape:Quests_OnDisable()
end

function Windcape:Quests_PlayerEnteringWorld() 
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