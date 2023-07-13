-- Copyright (c) 2023 Claus Jørgensen

Windcape_AutoRepair = Windcape:NewModule("AutoRepair", "AceEvent-3.0")

function Windcape_AutoRepair:OnEnable()
    self:RegisterEvent("MERCHANT_SHOW")
end

function Windcape_AutoRepair:OnDisable()
    self:UnregisterEvent("MERCHANT_SHOW")
end

function Windcape_AutoRepair:MERCHANT_SHOW()
    if not CanMerchantRepair() then
        return
    end

    repairAllCost, canRepair = GetRepairAllCost()
    if not canRepair then
        return
    end

    if repairAllCost <= GetMoney() then
        RepairAllItems()
        DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for " .. GetCoinText(repairAllCost,", ") .. ".", 255, 255, 0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money to repair!", 255, 0, 0)
    end
end
