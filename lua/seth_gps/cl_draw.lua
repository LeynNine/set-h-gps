--[[
	name: cl_draw.lua
]]--

Seth.Area.DRAW = Seth.Area.DRAW or {}
local DRAW = Seth.Area.DRAW
DRAW.tblPoints = DRAW.tblPoints or {}

-- MAT
local MAT_ARROW_MARKER = Material( "materials/seth_area/arrow_marker.png" )
local MAT_CIRCLE_MARKER = Material( "materials/seth_area/circle_marker.png" )																																																																																																											--[[ 76561198180318085 ]]--
local MAT_ADD = Material( "materials/seth_area/add.png" )
local MAT_REMOVE = Material( "materials/seth_area/remove.png" )

-- INT
local INT_SCRW, INT_SCRH = ScrW(), ScrH()

-- COLOR
local COL_BLACK = Color(200, 200, 200)

// Draw 3D position
local function Point3D(strName, vecPos, colMarker)
	local pPlayer = LocalPlayer()
	if !pPlayer or !pPlayer:Alive() then return end
	if !strName then return end
	if !vecPos then return end
	if !colMarker then return end

	local angRotate = Angle( 0, 0, 0 )
	local vecPos = vecPos + Vector( 0, 0, 2 )
	local intDist = math.Round( pPlayer:GetPos():Distance( vecPos ) *.1 )
	local intAnimCircle = math.abs( math.sin( CurTime() ) * .3 ) +.8

	if intDist < Seth.Area.CONFIG.DistanceToTransformPoint and intDist > Seth.Area.CONFIG.DistanceToRemovePoint then
		cam.Start3D2D( vecPos, angRotate, .1 )
			Seth.Area.UTIL:DrawMaterial(colMarker, MAT_CIRCLE_MARKER, -150 *intAnimCircle, -150 *intAnimCircle, 300 *intAnimCircle, 300 *intAnimCircle)
		cam.End3D2D()

		angRotate = Angle( 0, pPlayer:EyeAngles().y - 90, 90 )
		vecPos = vecPos +Vector( 0, 0, math.abs( math.sin( CurTime() ) * 5 ) )
		cam.Start3D2D( vecPos, angRotate, .1 )
			draw.SimpleTextOutlined( string.upper( strName ), "Seth:Area:Purista:45:Bold", 0, -440, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 100 ) )
			draw.SimpleTextOutlined( Seth.Area.LANGUAGE:Get( "DRAW:Distance" ).. ":".. intDist.. Seth.Area.LANGUAGE:Get( "DRAW:Unit" ), "Seth:Area:Purista:35:Italic", 0, -400, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 100 ) )

			Seth.Area.UTIL:DrawMaterial(colMarker, MAT_ARROW_MARKER, -100, -325, 200, 125)
		cam.End3D2D()
	end

	if !pPlayer["SA_MOD"] and intDist < Seth.Area.CONFIG.DistanceToRemovePoint then
		if DRAW.tblPoints[strName] then
			DRAW.tblPoints[strName].Active = false
			DRAW.tblPoints[strName].Checkbox:SetCheckToggle(false)

			Seth.Area.NOTIFY:AddNotify("[ ".. strName.. " ] - ".. Seth.Area.LANGUAGE:Get( "NOTIFY:Arrived" ), true, 5)
		end
	end
end

// Draw the loop of 3D positions
function DRAW:Points3D()
	local pPlayer = LocalPlayer()
	if !pPlayer or !pPlayer:Alive() then return end

	if !self.tblPoints or table.Count( self.tblPoints ) <1 then return end
	for strName, tblData in pairs(self.tblPoints or {}) do
		if pPlayer["SA_MOD"] or tblData.Active then
			Point3D(strName, tblData.Vector, tblData.Color)
		end
	end
end

// Reset the checkbox on GPS menu
function DRAW:ResetCheckbox()
	if !self.tblPoints or table.Count(self.tblPoints) <1 then return end
	for strName, tblData in pairs(self.tblPoints or {}) do
		self.tblPoints[strName].Active = false
		if !self.tblPoints[strName].Checkbox then continue end
		self.tblPoints[strName].Checkbox:SetCheckToggle(true)
	end
end

// Draw 2D position
local function Point2D(strName, vecPos, colMarker)
	local pPlayer = LocalPlayer()
	if !pPlayer or !pPlayer:Alive() then return end
	if !strName then return end
	if !vecPos then return end
	if !colMarker then return end

	local intDist = math.Round( pPlayer:GetPos():Distance( vecPos ) *.1 )
	if intDist < Seth.Area.CONFIG.DistanceToTransformPoint then return end

	local tblPosToScreen = vecPos:ToScreen()
	local intPosX, intPosY = tblPosToScreen.x, tblPosToScreen.y -50

	draw.SimpleTextOutlined( string.upper( strName ), "Seth:Area:Purista:22:Bold", intPosX, intPosY, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 100 ) )
	draw.SimpleTextOutlined( Seth.Area.LANGUAGE:Get( "DRAW:Distance" ).. ":".. intDist.. Seth.Area.LANGUAGE:Get( "DRAW:Unit" ), "Seth:Area:Purista:16:Italic", intPosX, intPosY +20, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 100 ) )

	surface.SetDrawColor( colMarker )
	surface.SetMaterial( MAT_ARROW_MARKER )
	surface.DrawTexturedRect( intPosX -48 -10, intPosY +3, 48, 32 )
end

// Draw the loop of 2D positions
function DRAW:Points2D()
	local pPlayer = LocalPlayer()
	if !pPlayer or !pPlayer:Alive() then return end


	if !self.tblPoints or table.Count( self.tblPoints ) <1 then return end
	for strName, tblData in pairs( self.tblPoints or {} ) do
		if pPlayer[ "SA_MOD" ] or tblData.Active then
			Point2D( strName, tblData.Vector, tblData.Color )
		end
	end
end

// Displays administration mode information 
function DRAW:HUDPaint()
	local intBackgroundWeight, intBackgroundHeight = 240, 50
	local intTextureBoxWeight = 50

	draw.RoundedBox( 16, INT_SCRW *.5 -intBackgroundWeight -5, 5, intBackgroundWeight, intBackgroundHeight, Color( 40, 40, 40 ) )
	draw.RoundedBox( 16, INT_SCRW *.5 +5, 5, intBackgroundWeight, intBackgroundHeight, Color( 40, 40, 40 ) )

	Seth.Area.UTIL:DrawMaterial(color_white, MAT_REMOVE, INT_SCRW *.5 -5 -32 -15, 5 +25 -16, 32, 32)
	Seth.Area.UTIL:DrawMaterial(color_white, MAT_ADD, INT_SCRW *.5 +5 +15, 5 +25 -16, 32, 32)

	draw.SimpleText(Seth.Area.LANGUAGE:Get("DRAW:LeftClick"), "Seth:Area:Purista:18:Bold", INT_SCRW *.5 -intTextureBoxWeight -15, 15, COL_BLACK, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	draw.SimpleText(Seth.Area.LANGUAGE:Get("DRAW:RemovePoint") , "Seth:Area:Purista:16:Italic", INT_SCRW *.5 -intTextureBoxWeight -15, 30, COL_BLACK, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	draw.SimpleText(Seth.Area.LANGUAGE:Get("DRAW:RightClick"), "Seth:Area:Purista:18:Bold", INT_SCRW *.5 +intTextureBoxWeight +15, 15, COL_BLACK, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(Seth.Area.LANGUAGE:Get("DRAW:AddPoint"), "Seth:Area:Purista:16:Italic", INT_SCRW *.5 +intTextureBoxWeight +15, 30, COL_BLACK, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end