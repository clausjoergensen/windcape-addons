-- Copyright (c) 2020 Claus Jørgensen

local autoRepairFrame = CreateFrame("Frame")

function Windcape:AutoRepair_OnEnable()
	autoRepairFrame:SetScript("OnEvent", (function(self, event, ...)
		if event == "MERCHANT_SHOW" and CanMerchantRepair() == true then
			repairAllCost, canRepair = GetRepairAllCost()
			if canRepair then
				if repairAllCost <= GetMoney() then
					RepairAllItems(false);
					DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for " .. GetCoinText(repairAllCost,", "), 255, 255, 0);
				else
					DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money for repair!", 255, 0, 0);
				end
			end
		end
	end))
	autoRepairFrame:RegisterEvent("MERCHANT_SHOW")
end

function Windcape:AutoRepair_OnDisable()
	autoRepairFrame:SetScript("OnEvent", nil)
end
