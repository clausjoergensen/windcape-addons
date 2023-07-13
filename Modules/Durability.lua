-- Copyright (c) 2023 Claus Jørgensen

Windcape_Durability = Windcape:NewModule("Durability", "AceEvent-3.0")

local DurabilityText = Minimap:CreateFontString(nil, "ARTWORK")

function Windcape_Durability:OnEnable()
    DurabilityText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    DurabilityText:SetPoint("TOPRIGHT", -3, -4) -- Designed to work with BasicMinimap (Square)

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
end

function Windcape_Durability:OnDisable()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")
end

function Windcape_Durability:PLAYER_ENTERING_WORLD()
    self:UpdateDurability()
end

function Windcape_Durability:UPDATE_INVENTORY_DURABILITY()
    self:UpdateDurability()
end

function Windcape_Durability:UpdateDurability()
    local totalCurrentDurability, totalMaximumDurability = self:GetDurability()
    local durabilityPercentage = 100 / totalMaximumDurability * totalCurrentDurability

    DurabilityText:SetText(math.floor(durabilityPercentage) .. "%")
end

function Windcape_Durability:GetDurability()
    local itemSlots = {
        "HEADSLOT",
        "NECKSLOT",
        "SHOULDERSLOT",
        "CHESTSLOT",
        "WAISTSLOT",
        "LEGSSLOT",
        "FEETSLOT",
        "WRISTSLOT",
        "HANDSSLOT",
        "MAINHANDSLOT",
        "SECONDARYHANDSLOT", -- offhands doesn't have durability, but shields do
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
