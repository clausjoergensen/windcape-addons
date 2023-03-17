-- Copyright (c) 2021 Claus Jørgensen

function Windcape:AutoRepair_OnEnable()
    self:RegisterEvent("MERCHANT_SHOW", "AutoRepair_MerchantShow")
end

function Windcape:AutoRepair_OnDisable()
    self:UnregisterEvent("MERCHANT_SHOW")
end

function Windcape:AutoRepair_MerchantShow()
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