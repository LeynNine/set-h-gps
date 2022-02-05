--[[
	name: cl_gps.lua
]]--

-- INT
local INT_W, INT_H = ScrW(), ScrH()
local INT_ANIM_TIME = .5
local INT_SPACING_X, INT_SPACING_Y = 5, 5

-- MAT
local MAT_HEADER = Material( "materials/seth_area/gps.png" )
local MAT_POINT = Material( "materials/seth_area/point.png" )
local MAT_DESC = Material( "materials/seth_area/description.png" )
local MAT_SETTINGS = Material( "materials/seth_area/settings.png" )

CreateClientConVar("seth_gps_x", tostring(INT_W -260 -INT_SPACING_X)) 
CreateClientConVar("seth_gps_y", tostring(INT_SPACING_Y)) 

--[[-------------------------------------------------------------------------
	Name: SethArea_DescPanel
	Desc: Description panel on hovered any panel
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	self:SetWide( 250 )
	self:SetTexture( MAT_DESC )

	self.pnlDescLabel = vgui.Create( "DLabel", self )
	self.pnlDescLabel:SetTextColor( Color( 150, 150, 150 ) )
	self.pnlDescLabel:SetFont( "Seth:Area:Purista:16" )
	self.pnlDescLabel:SetContentAlignment( 7 )
	self.pnlDescLabel:SetPos( 10, 55 )
	self.pnlDescLabel:SetWide( self:GetWide() )
end

function PANEL:SetText( strDesc )
	surface.SetFont( self.pnlDescLabel:GetFont() )
	local intCharWide = select( 1, surface.GetTextSize( "c" ) )
	self.strDesc, self.intDescLine = Seth.Area.UTIL:SplitString( strDesc, self:GetWide() /intCharWide -2 )

	self:SetTall( 60 +self.intDescLine *16 +5 )
	self.pnlDescLabel:SetText( self.strDesc )
	self.pnlDescLabel:SetTall( self:GetTall() -60 )
end

vgui.Register( "SethArea_DescPanel", PANEL, "SethArea_Frame" )

--[[-------------------------------------------------------------------------
	Name: SethArea_PointPanel
	Desc: Point panel to gps panel
---------------------------------------------------------------------------]]

local PANEL = {}
function PANEL:Init()
	self.btnCheckBox = vgui.Create( "SethArea_CheckBox", self )
	function self.btnCheckBox:SetActive()
		local pnlParent = self:GetParent()
		if !pnlParent then return false end
		local strName = pnlParent.strPointName

		if !Seth.Area.DRAW.tblPoints or !Seth.Area.DRAW.tblPoints[ strName ] then return false end
		if Seth.Area.DRAW.tblPoints[ strName ].Vector:Distance( LocalPlayer():GetPos() ) < 50 then
			Seth.Area.NOTIFY:AddNotify( "[ ".. strName.. " ] - ".. Seth.Area.LANGUAGE:Get( "NOTIFY:PointNear" ), false, 5 )
			return false
		end

		Seth.Area.DRAW.tblPoints[ strName ].Active = !Seth.Area.DRAW.tblPoints[ strName ].Active
		if Seth.Area.DRAW.tblPoints[ strName ].Active then
			Seth.Area.NOTIFY:AddNotify( "[ ".. strName.. " ] - ".. Seth.Area.LANGUAGE:Get( "NOTIFY:PointEnabled" ), true, 5 )
		else
			Seth.Area.NOTIFY:AddNotify( "[ ".. strName.. " ] - ".. Seth.Area.LANGUAGE:Get( "NOTIFY:PointDisabled" ), true, 5 )
		end

		return true
	end
end

function PANEL:SetPoint( strName, tblPoint )
	self.strPointName = strName
	self.strDesc = tblPoint.Desc
	self.colPoint = tblPoint.Color

	Seth.Area.DRAW.tblPoints[ strName ].Active = false
	Seth.Area.DRAW.tblPoints[ strName ].Checkbox = self.btnCheckBox
end

function PANEL:OnCursorEntered()
	local pnlParent = self:GetParent()
	if pnlParent:GetName() != "SethArea_GPS" then
		pnlParent = pnlParent:GetParent():GetParent()
	end
	if !pnlParent then return end

	local intX, intY = pnlParent:GetPos()
	if intX +pnlParent:GetWide() >= ScrW() *.5 then
		intX = intX -250 -5
	else
		intX = intX +260 +5
	end
	
	self.pnlDesc = vgui.Create( "SethArea_DescPanel" )
	self.pnlDesc:SetTitle( self.strPointName )
	self.pnlDesc:SetText( self.strDesc )
	self.pnlDesc:SetPos(intX, intY)
	self.pnlDesc:SetAlpha(0)
	self.pnlDesc:AlphaTo(255, .2)
end

function PANEL:OnCursorExited()
	local pnlParent = self:GetParent()
	if pnlParent:GetName() != "SethArea_GPS" then
		pnlParent = pnlParent:GetParent():GetParent()
	end
	if !pnlParent then return end

	if ValidPanel(self.pnlDesc) then
		self.pnlDesc:AlphaTo(0, .2, 0, function()
			if ValidPanel(self.pnlDesc) then
				self.pnlDesc:Remove()
			end	
		end)
	end
end

function PANEL:PerformLayout( intW, intH )
	self.btnCheckBox:SetPos( intW -self.btnCheckBox:GetWide() -10, intH *.5 -self.btnCheckBox:GetTall() *.5 )
end

function PANEL:Paint( intW, intH )
	draw.SimpleText( self.strPointName, "Seth:Area:Purista:16", 45, intH *.5, self.Hovered and Color( 255, 255, 255 ) or Color( 150, 150, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	draw.RoundedBox( 16, 10, intH *.5 -8, 16, 16, self.colPoint )
end

vgui.Register( "SethArea_PointPanel", PANEL, "DPanel" )

--[[-------------------------------------------------------------------------
	Name: SethArea_GPS
	Desc: GPS Panel of seth area
---------------------------------------------------------------------------]]

local PANEL = {}
function PANEL:Init()
	self:SetWide( 260 )
	self:SetPos(GetConVar("seth_gps_x"):GetInt(), GetConVar("seth_gps_y"):GetInt())
	self:SetTexture( MAT_HEADER )
	self:SetTitle( Seth.Area.LANGUAGE:Get( "VGUI:GPSTitle" ) )

	local tblPoints = Seth.Area.DRAW.tblPoints
	local intPointCount = table.Count( tblPoints )
	local bolCleanSize = intPointCount *55 +85 > INT_H *.5

	if bolCleanSize then
		self.pnlScroll = vgui.Create( "SethArea_Scroll", self )
		self.pnlScroll:SetSize( self:GetWide() -10, INT_H *.5 -85 -10 )
		self.pnlScroll:SetPos( 0, 55 )
	end

	local intSpacing = 0
	self.tblPointPanel = {}
	for strName, tblPoint in pairs( tblPoints ) do
		self.tblPointPanel[ strName ] = bolCleanSize and self.pnlScroll:Add( "SethArea_PointPanel" ) or vgui.Create( "SethArea_PointPanel", self )
		self.tblPointPanel[ strName ]:SetSize( bolCleanSize and self:GetWide() -30 or self:GetWide() -10, 50 )
		self.tblPointPanel[ strName ]:SetPos( 5, bolCleanSize and intSpacing or 55 +intSpacing )
		self.tblPointPanel[ strName ]:SetPoint( strName, tblPoint )

		intSpacing = intSpacing +55
	end
	self.intMaxTall = bolCleanSize and INT_H *.5 or 55 +intPointCount *55 +30
	self:SetTall( Seth.Area.CONFIG.MenuIsOpenOnSpawn and self.intMaxTall or 80 )

	self.btnReduce = vgui.Create( "SethArea_Button", self )
	self.btnReduce:SetSize( self:GetWide(), 30 )
	self.btnReduce:SetPos( 0, self:GetTall() -self.btnReduce:GetTall() )
	self.btnReduce:SetButtonText( Seth.Area.LANGUAGE:Get( "VGUI:GPSClose" ) )
	self.btnReduce:SetRounded( 16, false, false, true, true )
	self.btnReduce:SetBackgroundColor( Color( 26, 82, 118 ) )
	self.btnReduce:SetBackgroundHoveredColor( Color( 36, 110, 157 ) )
	self.intOldTime = CurTime() -2
	function self.btnReduce:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent or !IsValid( pnlParent ) then return end

		if CurTime() -pnlParent.intOldTime <2 then return end
		pnlParent.intOldTime = CurTime()
		local bolReduce = pnlParent:GetTall() > 80

		self:AlphaTo( 0, INT_ANIM_TIME, 0, function()
			for _, pnlPoint in pairs( pnlParent.tblPointPanel ) do
				pnlPoint:AlphaTo( bolReduce and 0 or 255, INT_ANIM_TIME, 0, function()
					pnlPoint:SetVisible( bolReduce and false or true )
				end)
			end

			if pnlParent.pnlScroll and IsValid( pnlParent.pnlScroll ) then
				pnlParent.pnlScroll:AlphaTo( bolReduce and 0 or 255, INT_ANIM_TIME, 0, function()
					pnlParent.pnlScroll:SetVisible( bolReduce and false or true )
				end)
			end

			pnlParent:SizeTo( pnlParent:GetWide(), bolReduce and 80 or pnlParent.intMaxTall, INT_ANIM_TIME, 0, -1, function()
				self:SetPos( 0, pnlParent:GetTall() -self:GetTall() )
				self:SetButtonText( bolReduce and Seth.Area.LANGUAGE:Get( "VGUI:GPSOpen" ) or Seth.Area.LANGUAGE:Get( "VGUI:GPSClose" ) )
				self:AlphaTo( 255, INT_ANIM_TIME )
			end)
		end)
	end

	self.pnlPositionBtn = vgui.Create("DImageButton", self)
	self.pnlPositionBtn:SetSize(27, 27)
	self.pnlPositionBtn:SetPos(self:GetWide() -self.pnlPositionBtn:GetWide() -15, 50 *.5 -self.pnlPositionBtn:GetTall() *.5)
	self.pnlPositionBtn:SetMaterial(MAT_SETTINGS)
	function self.pnlPositionBtn:DoClick()
		vgui.Create("SethArea_ShadowFrame")
	end
end

vgui.Register( "SethArea_GPS", PANEL, "SethArea_Frame" )
