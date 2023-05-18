-- Copyright (c) 2023 Claus Jørgensen

Durability = Windcape:NewModule("Durability", "AceEvent-3.0")

local durabilityText = Minimap:CreateFontString(nil, "ARTWORK")

function Durability:OnEnable()
    durabilityText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    durabilityText:SetPoint("TOPLEFT", 4, -4)

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
end

function Durability:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")
end

function Durability:PLAYER_ENTERING_WORLD()
    self:UpdateDurability()
end

function Durability:UPDATE_INVENTORY_DURABILITY()
    self:UpdateDurability()
end

function Durability:UpdateDurability()
    local totalCurrentDurability, totalMaximumDurability = self:GetDurability()
    local durabilityPercentage = 100 / totalMaximumDurability * totalCurrentDurability
    durabilityText:SetText(math.floor(durabilityPercentage) .. "%")
end

function Durability:GetDurability()
    local itemSlots = {
        "HEADSLOT",
        "NECKSLOT",
        "SHOULDERSLOT",
        "SHIRTSLOT",
        "CHESTSLOT",
        "WAISTSLOT",
        "LEGSSLOT",
        "FEETSLOT",
        "WRISTSLOT",
        "HANDSSLOT",
        "FINGER0SLOT",
        "FINGER1SLOT",
        "TRINKET0SLOT",
        "TRINKET1SLOT",
        "BACKSLOT",
        "MAINHANDSLOT",
        "SECONDARYHANDSLOT",
        "RANGEDSLOT"
    }
    
    local totalCurrentDurability = 0
    local totalMaximumDurability = 0
    
    for _, invSlotName in ipairs(itemSlots) do
        local invSlotId = GetInventorySlotInfo(invSlotName)
        local currentDurability, maximumDurability = GetInventoryItemDurability(invSlotId)
        if currentDurability and maximumDurability then
            totalCurrentDurability = totalCurrentDurability + currentDurability
            totalMaximumDurability = totalMaximumDurability + maximumDurability
        end
    end

    return totalCurrentDurability, totalMaximumDurability
end