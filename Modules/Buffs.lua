-- Copyright (c) 2021 Claus Jørgensen

Windcape_Buffs = Windcape:NewModule("Buffs", "AceEvent-3.0", "AceHook-3.0")

local Masque = LibStub("Masque", true)

function Windcape_Buffs:OnEnable()
    self:SecureHook("UIParent_UpdateTopFramePositions", "UpdateTopFramePositions")

    if Masque then
        self.buffs = Masque:Group("Windcape", "Buffs")
        self.debuffs = Masque:Group("Windcape", "Debuffs")
        self.tmpEnchants = Masque:Group("Windcape", "Temp Enchants")
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:SecureHook("CreateFrame", "OnCreateFrame")
end

function Windcape_Buffs:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_Buffs:UpdateTopFramePositions()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetScale(1.0)
    BuffFrame:SetPoint("TOPRIGHT", "Minimap", "TOPLEFT", -10, 0)
end

function Windcape_Buffs:PLAYER_ENTERING_WORLD()
    for i = 1, BUFF_MAX_DISPLAY do
        local buffFrame = _G["BuffButton" .. i]
        if not buffFrame then
            break
        end
        self.buffs:AddButton(buffFrame)
    end

    for i = 1, BUFF_MAX_DISPLAY do
        local debuffFrame = _G["DebuffButton" .. i]
        if not debuffFrame then
            break
        end
        self.debuffs:AddButton(debuffFrame)
    end

    for i = 1, NUM_TEMP_ENCHANT_FRAMES do
        local tmpEnchantFrame = _G["TempEnchant" .. i]
        self.tmpEnchants:AddButton(tmpEnchantFrame)
        _G["TempEnchant" .. i .. "Border"]:SetVertexColor(.75, 0, 1)
    end
end

function Windcape_Buffs:OnCreateFrame(_, name, parent)
    if parent ~= BuffFrame or type(name) ~= "string" then
        return
    end

    if strfind(name, "^DebuffButton%d+$") then
        self.debuffs:AddButton(_G[name])
        self.debuffs:ReSkin()
    elseif strfind(name, "^BuffButton%d+$") then
        self.buffs:AddButton(_G[name])
        self.buffs:ReSkin()
    end
end