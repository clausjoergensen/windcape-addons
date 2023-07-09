-- Copyright (c) 2023 Claus Jørgensen

Windcape_GearScore = Windcape:NewModule("GearScore", "AceEvent-3.0")

local GearScoreText = CharacterModelFrame:CreateFontString(nil, "ARTWORK")

function Windcape_GearScore:OnEnable()
    GearScoreText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    GearScoreText:SetPoint("BOTTOMLEFT", 8, 40)

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
end

function Windcape_GearScore:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function Windcape_GearScore:PLAYER_ENTERING_WORLD()
    self:UpdateGearScore()
end

function Windcape_GearScore:PLAYER_EQUIPMENT_CHANGED()
    self:UpdateGearScore()
end

function Windcape_GearScore:UpdateGearScore() 
    local gearScore, itemLevel = self:GetScore("player")
    GearScoreText:SetText(format("%u / %u", gearScore, itemLevel))
end

function Windcape_GearScore:GetItemScore(itemLink)
    local itemTypes = {
        ["INVTYPE_RELIC"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false},
        ["INVTYPE_TRINKET"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 33, ["Enchantable"] = false },
        ["INVTYPE_2HWEAPON"] = { ["SlotMOD"] = 2.000, ["ItemSlot"] = 16, ["Enchantable"] = true },
        ["INVTYPE_WEAPONMAINHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 16, ["Enchantable"] = true },
        ["INVTYPE_WEAPONOFFHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
        ["INVTYPE_RANGED"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = true },
        ["INVTYPE_THROWN"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
        ["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
        ["INVTYPE_SHIELD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
        ["INVTYPE_WEAPON"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 36, ["Enchantable"] = true },
        ["INVTYPE_HOLDABLE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = false },
        ["INVTYPE_HEAD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 1, ["Enchantable"] = true },
        ["INVTYPE_NECK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 2, ["Enchantable"] = false },
        ["INVTYPE_SHOULDER"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 3, ["Enchantable"] = true },
        ["INVTYPE_CHEST"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
        ["INVTYPE_ROBE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
        ["INVTYPE_WAIST"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 6, ["Enchantable"] = false },
        ["INVTYPE_LEGS"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 7, ["Enchantable"] = true },
        ["INVTYPE_FEET"] = { ["SlotMOD"] = 0.75, ["ItemSlot"] = 8, ["Enchantable"] = true },
        ["INVTYPE_WRIST"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 9, ["Enchantable"] = true },
        ["INVTYPE_HAND"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 10, ["Enchantable"] = true },
        ["INVTYPE_FINGER"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 31, ["Enchantable"] = false },
        ["INVTYPE_CLOAK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 15, ["Enchantable"] = true },
        ["INVTYPE_BODY"] = { ["SlotMOD"] = 0, ["ItemSlot"] = 4, ["Enchantable"] = false },
    }
    
    if not itemLink then
        return 0, 0
    end
    
    local _, itemLink, itemRarity, itemLevel, _, _, _, _, itemEquipLoc, _ = GetItemInfo(itemLink)    
    if not (itemLink and itemRarity and itemLevel and itemEquipLoc and itemTypes[itemEquipLoc]) then
        return 0, 0
    end
    
    local qualityScale = 1
    
    if itemRarity == 5 then 
        qualityScale = 1.3
        itemRarity = 4
    elseif itemRarity == 1 then
        qualityScale = 0.005
        itemRarity = 2
    elseif itemRarity == 0 then
        qualityScale = 0.005
        itemRarity = 2
    elseif itemRarity == 7 then
        itemRarity = 3
        itemLevel = 187.05
    end

    local table
    if itemLevel > 120 then
        table = {
            [4] = { ["A"] = 91.4500, ["B"] = 0.6500 },
            [3] = { ["A"] = 81.3750, ["B"] = 0.8125 },
            [2] = { ["A"] = 73.0000, ["B"] = 1.0000 }
        }
    else
        table = {
            [4] = { ["A"] = 26.0000, ["B"] = 1.2000 },
            [3] = { ["A"] = 0.7500, ["B"] = 1.8000 },
            [2] = { ["A"] = 8.0000, ["B"] = 2.0000 },
            [1] = { ["A"] = 0.0000, ["B"] = 2.2500 }
        }
    end
    
    if not (itemRarity >= 2 and itemRarity <= 4) then
        return 0, 0
    end
        
    local scale = 1.8618
    local gearScore = floor(((itemLevel - table[itemRarity].A) / table[itemRarity].B) * itemTypes[itemEquipLoc].SlotMOD * scale * qualityScale)

    if itemLevel == 187.05 then
        itemLevel = 0
    end

    if gearScore < 0 then
        gearScore = 0
    end

    return gearScore, itemLevel
end

function Windcape_GearScore:GetScore(unitId)
    local isHunter = select(2, UnitClass(unitId)) == "HUNTER"
    local gearScore = 0
    local itemCount = 0
    local levelTotal = 0
    local titanGrip = 1
    
    local mainHandItem = GetInventoryItemLink(unitId, 16)
    local offHandItem = GetInventoryItemLink(unitId, 17)
    
    if mainHandItem and offHandItem then
        local _, _, _, itemLevel, _, _, _, _, itemEquipLoc, _ = GetItemInfo(mainHandItem)
        if itemEquipLoc == "INVTYPE_2HWEAPON" then
            titanGrip = 0.5
        end
    end
    
    if offHandItem then
        local _, _, _, _, _, _, _, _, itemEquipLoc, _ = GetItemInfo(offHandItem)
        if itemEquipLoc == "INVTYPE_2HWEAPON" then
            titanGrip = 0.5
        end
        
        local tempScore, itemLevel = self:GetItemScore(offHandItem)
        if isHunter then
            tempScore = tempScore * 0.3164
        end
        
        gearScore = gearScore + tempScore * titanGrip
        itemCount = itemCount + 1
        levelTotal = levelTotal + itemLevel
    end
    
    for i = 1, 18 do
        if i ~= 4 and i ~= 17 then
            local item = GetInventoryItemLink(unitId, i)
            if item then
                local tempScore, itemLevel = self:GetItemScore(item)
                
                if isHunter then
                    if i == 16 then
                        tempScore = tempScore * 0.3164
                    elseif i == 18 then
                        tempScore = tempScore * 5.3224
                    end
                end
                
                if i == 16 then
                    tempScore = tempScore * titanGrip
                end
                
                gearScore = gearScore + tempScore
                itemCount = itemCount + 1
                levelTotal = levelTotal + itemLevel
            end
        end
    end
    
    if not (gearScore > 0 and itemCount > 0) then
        return 0, 0
    end
    
    return floor(gearScore), floor(levelTotal / itemCount)
end