-- Copyright (c) 2020 Claus Jørgensen

local LibWindow = LibStub("LibWindow-1.1")

function Windcape:WorldMap_OnEnable()
	LibWindow.RegisterConfig(WorldMapFrame, self.db.char)

	self:SecureHookScript(WorldMapFrame, 
		"OnDragStart", 
		"WorldMapFrame_OnDragStart")
	
	self:SecureHookScript(WorldMapFrame, 
		"OnDragStop", 
		"WorldMapFrame_OnDragStop")
	
	self:RawHook(WorldMapFrame, 
		"HandleUserActionToggleSelf", 
		"WorldMapFrame_HandleUserActionToggleSelf", 
		true)
	
	self:RawHook(WorldMapFrame.ScrollContainer, 
		"GetCursorPosition", 
		"WorldMapFrame_ScrollContainer_GetCursorPosition", 
		true)

	if WorldMapFrame.SynchronizeDisplayState then
		self:SecureHook(WorldMapFrame, 
			"SynchronizeDisplayState", 
			"WorldMapFrame_SynchronizeDisplayState")
	end

	WorldMapFrame.BlackoutFrame:Hide()
	WorldMapFrame:EnableMouse(true)
	WorldMapFrame:RegisterForDrag("LeftButton")
	WorldMapFrame:SetAttribute("UIPanelLayout-area", nil)
	WorldMapFrame:SetAttribute("UIPanelLayout-enabled", false)
	WorldMapFrame:SetIgnoreParentScale(false)
	WorldMapFrame:SetMovable(true)
	WorldMapFrame:SetUserPlaced(true)
	WorldMapFrame:SetClampedToScreen(true)

	-- removes the world map from the default panel system
	-- which is necessary in order to set a custom position
	UIPanelWindows["WorldMapFrame"] = nil
	
	-- allows dismissing the map with esc
	table.insert(UISpecialFrames, "WorldMapFrame")

	self:WorldMapFrame_SetScale()
	self:WorldMapFrame_RestorePosition()
end

function Windcape:WorldMapFrame_SetScale()
	WorldMapFrame:SetScale(1.0)
end

function Windcape:WorldMapFrame_SavePosition()
	LibWindow.SavePosition(WorldMapFrame)
end

function Windcape:WorldMapFrame_RestorePosition()
	LibWindow.RestorePosition(WorldMapFrame)
end

function Windcape:WorldMapFrame_ScrollContainer_GetCursorPosition(frame)
    local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(frame)
    local scale = frame:GetScale() * UIParent:GetEffectiveScale()
    return x / scale, y / scale
end

function Windcape:WorldMapFrame_HandleUserActionToggleSelf(frame) 
	if frame:IsShown() then
		frame:Hide()
	else 
		frame:Show() 
	end 
end

function Windcape:WorldMapFrame_SynchronizeDisplayState(frame)
	self:WorldMapFrame_SetScale()
	self:WorldMapFrame_RestorePosition()
end

function Windcape:WorldMapFrame_OnDragStart(frame)
	frame:StartMoving()
end

function Windcape:WorldMapFrame_OnDragStop(frame) 
	frame:StopMovingOrSizing()
	self:WorldMapFrame_SavePosition()
end
