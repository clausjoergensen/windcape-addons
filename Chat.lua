-- Copyright (c) 2020 Claus Jørgensen

function Windcape:Chat_OnEnable()
	self:ChatFrame_UpdateLayout()
	self:ChatFrame_EnableClassColors()
end

function Windcape:ChatFrame_EnableClassColors()
	SetCVar("chatClassColorOverride", "0")
end

function Windcape:ChatFrame_UpdateLayout()
	local FONT_SIZE = 14
	
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame" .. i]
		chatFrame:SetFont("Fonts\\FRIZQT__.TTF", FONT_SIZE, nil)
		chatFrame:SetClampedToScreen(false)

      	_G[chatFrame:GetName() .. "EditBoxLeft"]:Hide()
      	_G[chatFrame:GetName() .. "EditBoxRight"]:Hide()
      	_G[chatFrame:GetName() .. "EditBoxMid"]:Hide()

        local chatFrameEditBox = _G[chatFrame:GetName() .. "EditBox"]
        chatFrameEditBox:SetFont("Fonts\\FRIZQT__.TTF", FONT_SIZE, nil)
        chatFrameEditBox["SetAltArrowKeyMode"](chatFrameEditBox, false)
		chatFrameEditBox:ClearAllPoints()
		chatFrameEditBox:SetPoint('BOTTOMLEFT',  chatFrame:GetName(), 'TOPLEFT',  -5, 0)
		chatFrameEditBox:SetPoint('BOTTOMRIGHT', chatFrame:GetName(), 'TOPRIGHT', 5, 0)

        local chatFrameEditBoxHeader = _G[chatFrameEditBox:GetName() .. "Header"]
        chatFrameEditBoxHeader:SetFont("Fonts\\FRIZQT__.TTF", FONT_SIZE, nil)
	end
end