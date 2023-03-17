-- Copyright (c) 2021 Claus Jørgensen

local Masque = LibStub("Masque", true)

function Windcape:Buffs_OnEnable()
    self:SecureHook("UIParent_UpdateTopFramePositions", "Buffs_Move")

    if Masque then
        self.buffs = Masque:Group("Windcape", "Buffs")
        self.debuffs = Masque:Group("Windcape", "Debuffs")
        self.tmpEnchants = Masque:Group("Windcape", "Temp Enchants")
    end

    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Buffs_PlayerEnteringWorld")
    self:SecureHook("CreateFrame", "Buffs_CreateFrame")
end

function Windcape:Buffs_OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape:Buffs_Move()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetScale(1.0)
    BuffFrame:SetPoint("TOPRIGHT", "Minimap", "TOPLEFT", -10, 0)
end

function Windcape:Buffs_PlayerEnteringWorld()
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

function Windcape:Buffs_CreateFrame(_, name, parent)
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