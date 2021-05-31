-- Copyright (c) 2021 Claus Jørgensen

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
    self:WorldMapFrame_EnableCoordinates()
end

function Windcape:WorldMap_OnDisable()
    self:WorldMapFrame_DisableCoordinates()
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
    local x, y = MapCanvasScrollControllerMixin:GetCursorPosition(frame)
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

function Windcape:WorldMapFrame_EnableCoordinates()
    self.coordinatesFrame = CreateFrame("Frame",
        "Windcape_CoordsFrame",
        WorldMapFrame.ScrollContainer)

    self.cursorText = self.coordinatesFrame:CreateFontString(nil, "OVERLAY")
    self.cursorText:SetFont(GameFontNormal:GetFont(), 11, "OUTLINE")
    self.cursorText:SetTextColor(1, 1, 1)
    self.cursorText:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer, "BOTTOM", 30, -8)

    self.playerText = self.coordinatesFrame:CreateFontString(nil, "OVERLAY")
    self.playerText:SetFont(GameFontNormal:GetFont(), 11, "OUTLINE")
    self.playerText:SetTextColor(1, 1, 1)
    self.playerText:SetPoint("TOPRIGHT", WorldMapFrame.ScrollContainer, "BOTTOM", -30, -8)

    self:HookScript(self.coordinatesFrame,
        "OnUpdate",
        "CoordinatesFrame_OnUpdate")

    self.coordinatesFrame:Show()
end

function Windcape:WorldMapFrame_DisableCoordinates()
    if not self.coordinatesFrame then
        return
    end

    self:Unhook(self.coordinatesFrame, "OnUpdate")
end

function Windcape:CoordinatesFrame_OnUpdate()
    self:CoordinatesFrame_UpdateCusorCoordinates()
    self:CoordinatesFrame_UpdatePlayerCoordinates()
end

function Windcape:CoordinatesFrame_UpdateCusorCoordinates()
    local mouseX, mouseY = self:WorldMapFrame_GetMouseCoordinates()
    if mouseX < 0 or mouseX > 1 or mouseY < 0 or mouseY > 1 then
        return
    end

    if mouseX then
        self.cursorText:SetFormattedText("Cursor: %.1f, %.1f", 100 * mouseX, 100 * mouseY)
    else
        self.cursorText:SetText("")
    end
end

function Windcape:CoordinatesFrame_UpdatePlayerCoordinates()
    local playerMapPosition = C_Map.GetPlayerMapPosition(WorldMapFrame:GetMapID(), "player")
    if not playerMapPosition then
        return
    end

    local playerX, playerY = playerMapPosition:GetXY()
    if not playerX or playerX == 0 then
        self.playerText:SetText("")
    else
        self.playerText:SetFormattedText("Player: %.1f, %.1f", 100 * playerX, 100 * playerY)
    end
end

function Windcape:WorldMapFrame_GetMouseCoordinates()
    local scrollContainerChild = WorldMapFrame.ScrollContainer.Child
    local left = scrollContainerChild:GetLeft()
    local top = scrollContainerChild:GetTop()
    local width = scrollContainerChild:GetWidth()
    local height = scrollContainerChild:GetHeight()
    local scale = scrollContainerChild:GetEffectiveScale()

    if not left or not top then
        return
    end

    local x, y = GetCursorPosition()
    local cursorX = (x / scale - left) / width
    local cursorY = (top - y / scale) / height

    return cursorX, cursorY
end
