--[[
	name: cl_main.lua
]]--

local MAT_NOTIFY = Material( "materials/seth_area/notification.png" )
local MAT_POINT = Material( "materials/seth_area/point.png" )

--[[-------------------------------------------------------------------------
	Name: Frame
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	self.strTitle = "Title"
	self.matTexture = Material( "materials/seth_area/settings.png" )
end

function PANEL:SetTexture( matTexture )
	self.matTexture = matTexture
end

function PANEL:SetTitle( strTitle )
	self.strTitle = strTitle
end

function PANEL:Paint( intW, intH )
	draw.RoundedBox( 16, 0, 0, intW, intH, Color( 34, 34, 34 ) )

	surface.SetDrawColor( 40, 40, 40 )
	surface.DrawLine( 0, 50, intW, 50 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( self.matTexture )
	surface.DrawTexturedRect( 15, ( 50 *.5 ) -( 27 *.5 ), 27, 27 )

	draw.SimpleText( self.strTitle, "Seth:Area:Purista:16", 30 +27, 25, Color( 150, 150, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

vgui.Register( "SethArea_Frame", PANEL, "EditablePanel" )

--[[-------------------------------------------------------------------------
	Name: Button
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	self:SetText( "" )
end

function PANEL:SetRounded( intRounded, bolRoundFirst, bolRoundTwo, bolRoundThree, bolRoundFour )
	self.intRounded, self.bolRoundFirst, self.bolRoundTwo, self.bolRoundThree, self.bolRoundFour = intRounded, bolRoundFirst, bolRoundTwo, bolRoundThree, bolRoundFour
end

function PANEL:SetButtonText( strText )
	self.strText = strText
end

function PANEL:SetTextFont( fntText )
	self.fntText = fntText
end

function PANEL:SetBackgroundColor( colBackground )
	self.colBackground = colBackground
end

function PANEL:SetBackgroundHoveredColor( colBackgroundHovered )
	self.colBackgroundHovered = colBackgroundHovered
end

function PANEL:SetTextColor( colText )
	self.colText = colText
end

function PANEL:SetTextHoveredColor( colTextHovered )
	self.colTextHovered = colTextHovered
end

function PANEL:SetTexture( matTexture, intTextureWeight, intTextureHeight )
	self.matTexture, self.intTextureWeight, self.intTextureHeight = matTexture, intTextureWeight, intTextureHeight
end

function PANEL:Paint( intW, intH )
	if self.Hovered then
		self.colDefineText = self.colTextHovered or Color( 255, 255, 255 )
		self.colDefineBackground = self.colBackgroundHovered or Color( 0, 0, 0, 0 )
	else
		self.colDefineText = self.colText or Color( 220, 220, 220 )
		self.colDefineBackground = self.colBackground or Color( 0, 0, 0, 0 )
	end

	if self.colBackground and self.colBackgroundHovered then
		draw.RoundedBoxEx( self.intRounded, 0, 0, intW, intH, self.colDefineBackground, self.bolRoundFirst, self.bolRoundTwo, self.bolRoundThree, self.bolRoundFour )
	end

	if !self.matTexture then
		draw.SimpleText( self.strText or "Label", self.fntText or "Seth:Area:Purista:16", intW *.5, intH *.5, self.colDefineText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		surface.SetFont( self.fntText or "Seth:Area:Purista:16" )
		local intTextWeight = select( 1, surface.GetTextSize( self.strText or "Label" ) )
		local intSpacing = ( intTextWeight +self.intTextureWeight ) *.5

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( self.matTexture )
		surface.DrawTexturedRect( intW *.5 - intSpacing -7.5, ( intH *.5 ) -( self.intTextureHeight *.5 ), self.intTextureWeight, self.intTextureHeight )

		draw.SimpleText( self.strText or "Label", self.fntText or "Seth:Area:Purista:16", intW *.5 -intSpacing +self.intTextureHeight +7.5, intH *.5, self.colDefineText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
end

vgui.Register( "SethArea_Button", PANEL, "DButton" )

--[[-------------------------------------------------------------------------
	Name: Check box
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	self:SetSize( 30, 16 )
	self:SetText( "" )
	self.bolIsOn = false
end

function PANEL:SetCheckToggle( bolToggle )
	if bolToggle then
		self.bolIsOn = false
	else
		self.bolIsOn = !self.bolIsOn
	end
end

function PANEL:SetActive()
end

function PANEL:DoClick()
	if !self:SetActive() then return end
	self:SetCheckToggle()
end

function PANEL:Paint( intW, intH )
	draw.RoundedBox( 6, 0, 2, intW, intH -4, Color( 50, 50, 50 ) )

	self.intLerpActive = self.intLerpActive or 0
	self.intLerpActive = Lerp( FrameTime() *10, self.intLerpActive, self.bolIsOn and intW -intH or 0 )
	draw.RoundedBox( 8, self.intLerpActive, 0, intH, intH, self.bolIsOn and Color( 35, 155, 86 ) or Color( 176, 58, 46 ) )
end

vgui.Register( "SethArea_CheckBox", PANEL, "DButton" )

--[[-------------------------------------------------------------------------
	Name: Scroll
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	local tblBars = self:GetVBar()
	function tblBars.btnUp:Paint() end
	function tblBars.btnDown:Paint() end
	function tblBars:Paint( intW, intH )
		draw.RoundedBox( 0, intW *.5 -intW *.2 *.5, intH *.05, intW *.2, intH *.9, Color( 50, 50, 50 ) )
	end
	function tblBars.btnGrip:Paint( intW, intH )
		draw.RoundedBox( 8, intW *.5 -intW *.4 *.5, 0, intW *.4, intH, Color( 60, 60, 60 ) )
	end
end

vgui.Register( "SethArea_Scroll", PANEL, "DScrollPanel" )

--[[-------------------------------------------------------------------------
	Name: Text entry
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	self:SetDrawBackground( false )
	self:SetDrawLanguageID( false )
	self:SetFont( "Seth:Area:Purista:16:Italic" )
end

function PANEL:SetPlaceHolderText( strHolder )
	self.strHolder = strHolder
end

function PANEL:Paint( intW, intH )
	surface.SetDrawColor( 40, 40, 40 )
	surface.DrawRect( 0, 0, intW, intH )

	surface.SetDrawColor( 30, 30, 30 )
	surface.DrawOutlinedRect( 0, 0, intW, intH )

	self:DrawTextEntryText( Color( 150, 150, 150 ), Color( 212, 172, 13, 20 ), Color( 150, 150, 150 ) )

	if self.strHolder and self:GetText() == nil or self:GetText() == "" then
		draw.SimpleText( self.strHolder, "Seth:Area:Purista:16:Italic", 5, 2.5, Color( 150, 150, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
end

vgui.Register( "SethArea_TextEntry", PANEL, "DTextEntry" )

--[[-------------------------------------------------------------------------
	Name: Valid panel
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	self:SetWide( 350 )
	self:Center()
	self:SetTitle( Seth.Area.LANGUAGE:Get( "VGUI:ChoicePanelTItle" ) )
	self:MakePopup()
	self:SetTexture( MAT_POINT )

	self.pnlQuestionLabel = vgui.Create( "DLabel", self )
	self.pnlQuestionLabel:SetContentAlignment( 8 )
	self.pnlQuestionLabel:SetFont( "Seth:Area:Purista:16:Italic" )
	self.pnlQuestionLabel:SetColor( Color( 150, 150, 150 ) )

	self.pnlYesBtn = vgui.Create( "SethArea_Button", self )
	self.pnlYesBtn:SetSize( self:GetWide() *.5, 30 )
	self.pnlYesBtn:SetButtonText( Seth.Area.LANGUAGE:Get( "VGUI:ChoicePanelYes" ) )
	self.pnlYesBtn:SetRounded( 16, false, false, true, false )
	self.pnlYesBtn:SetBackgroundColor( Color( 35, 155, 86 ) )
	self.pnlYesBtn:SetBackgroundHoveredColor( Color( 46, 204, 113 ) )
	function self.pnlYesBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent or !IsValid( pnlParent ) then return end
		pnlParent:Remove()

		net.Start( "NET:Seth:Area" )
			net.WriteUInt( pnlParent.intID, 8 )
		net.SendToServer()
	end

	self.pnlNoBtn = vgui.Create( "SethArea_Button", self )
	self.pnlNoBtn:SetSize( self:GetWide() *.5, 30 )
	self.pnlNoBtn:SetButtonText( Seth.Area.LANGUAGE:Get( "VGUI:ChoicePanelNo" ) )
	self.pnlNoBtn:SetRounded( 16, false, false, false, true )
	self.pnlNoBtn:SetBackgroundColor( Color( 176, 58, 46 ) )
	self.pnlNoBtn:SetBackgroundHoveredColor( Color( 203, 67, 53 ) )
	function self.pnlNoBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent or !IsValid( pnlParent ) then return end
		pnlParent:Remove()
	end
end

function PANEL:SetNetID( intID )
	self.intID = intID
end

function PANEL:SetText( strText )
	self.strText, self.intCountLine = Seth.Area.UTIL:SplitString( strText, self:GetWide() /4.5 -30 )

	self:SetTall( self.intCountLine *18 +30 +65 +15 )

	self.pnlQuestionLabel:SetSize( self:GetWide() -30, 18 *self.intCountLine )
	self.pnlQuestionLabel:SetPos( 15, 65 )
	self.pnlQuestionLabel:SetText( self.strText )

	self.pnlYesBtn:SetPos( 0, self:GetTall() -self.pnlYesBtn:GetTall() )
	self.pnlNoBtn:SetPos( self:GetWide() *.5, self:GetTall() -self.pnlNoBtn:GetTall() )
end

vgui.Register( "SethArea_ValidPanel", PANEL, "SethArea_Frame" )

--[[-------------------------------------------------------------------------
	Name: Notify
---------------------------------------------------------------------------]]

local PANEL = {}

function PANEL:Init()
	self:SetTall( 50 )
	self.tblTriangle = { { x = self:GetTall() -5, y = 0 }, { x = self:GetTall() +15, y = 0 }, { x = self:GetTall() -5, y = self:GetTall() } }
end

function PANEL:SetType( bolType )
	self.strTitle = bolType and string.upper( Seth.Area.LANGUAGE:Get( "VGUI:Success" ) ) or string.upper( Seth.Area.LANGUAGE:Get( "VGUI:Error" ) )
end

function PANEL:SetText( strText )
	self.strText = strText

	surface.SetFont( "Seth:Area:Purista:16:Italic" )
	local intWeight = surface.GetTextSize( strText )
	self:SetWide( self:GetTall() +35 +intWeight +10 )
end

function PANEL:KillSelf()
	if ( self.intStartTime +self.intLength < SysTime() ) then
		self:Remove()
		return true
	end

	return false
end

function PANEL:Paint( intW, intH )
	draw.RoundedBox( 16, 0, 0, intW, intH, Color( 40, 40, 40 ) )
	draw.RoundedBoxEx( 16, 0, 0, intH -5, intH, Color( 26, 82, 118 ), true, false, true, false )

	surface.SetDrawColor( 26, 82, 118 )
	draw.NoTexture()
	surface.DrawPoly( self.tblTriangle )

	surface.SetDrawColor( 200, 200, 200 )
	surface.SetMaterial( MAT_NOTIFY )
	surface.DrawTexturedRect( intH *.5 -16, intH *.5 -16, 32, 32 )

	draw.SimpleText( self.strTitle or string.upper( Seth.Area.LANGUAGE:Get( "VGUI:Success" ) ), "Seth:Area:Purista:18:Bold", intH +25, intH *.5 -8, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( self.strText or  Seth.Area.LANGUAGE:Get( "VGUI:NotificationExemple" ), "Seth:Area:Purista:16:Italic", intH +25, intH *.5 +7, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

vgui.Register( "SethArea_Notify", PANEL, "DPanel" )

local PANEL = {}

function PANEL:Init()
	self.bolSwitch = true

	self.pnlLeftBtn = vgui.Create("SethArea_Button", self)
	self.pnlLeftBtn:SetButtonText("LEFT")
	self.pnlLeftBtn:SetRounded(24, true, false, true, false)
	self.pnlLeftBtn:SetBackgroundColor(Color(35,155,86))
	self.pnlLeftBtn:SetBackgroundHoveredColor(Color(53,187,110))
	self.pnlLeftBtn:SetTextColor(color_white)
	self.pnlLeftBtn:SetTextFont("Seth:Area:Purista:20:Italic")
	function self.pnlLeftBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		
		pnlParent.bolSwitch = true
		pnlParent:Switch()
	end

	self.pnlRightBtn = vgui.Create("SethArea_Button", self)
	self.pnlRightBtn:SetButtonText("RIGHT")
	self.pnlRightBtn:SetRounded(24, false, true, false, true)
	self.pnlRightBtn:SetBackgroundColor(Color(70,70,70))
	self.pnlRightBtn:SetBackgroundHoveredColor(Color(75, 75, 75))
	self.pnlRightBtn:SetTextColor(Color(150,150,150))
	self.pnlRightBtn:SetTextFont("Seth:Area:Purista:20:Italic")
	function self.pnlRightBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		
		pnlParent.bolSwitch = false
		pnlParent:Switch()
	end
end

function PANEL:Switch()
	self.pnlRightBtn:SetTextColor(self.bolSwitch and Color(150,150,150) or color_white)
	self.pnlRightBtn:SetBackgroundColor(self.bolSwitch and Color(70,70,70) or Color(35,155,86))
	self.pnlRightBtn:SetBackgroundHoveredColor(self.bolSwitch and Color(75, 75, 75) or Color(53,187,110))

	self.pnlLeftBtn:SetTextColor(self.bolSwitch and color_white or Color(150,150,150))
	self.pnlLeftBtn:SetBackgroundColor( self.bolSwitch and Color(35,155,86) or Color(70,70,70))
	self.pnlLeftBtn:SetBackgroundHoveredColor(self.bolSwitch and Color(53,187,110) or Color(75, 75, 75))
end

function PANEL:GetSwitchValue()
	return self.bolSwitch or false
end

function PANEL:PerformLayout(intW, intH)
	self.pnlLeftBtn:Dock(LEFT)
	self.pnlLeftBtn:SetWide(self:GetWide() *.5)

	self.pnlRightBtn:Dock(RIGHT)
	self.pnlRightBtn:SetWide(self:GetWide() *.5)
end

function PANEL:Paint() 
end

vgui.Register("SethArea_ButtonGroup", PANEL, "DPanel")

local PANEL = {}

function PANEL:Init()
	self:SetTall(50)
	self:SetTall(100)
	self:SetDecimals(0)
	self:SetText("")
	self:SetValue(0)
	self.Scratch:SetVisible(false)
	self.Label:SetVisible(false)
	self.TextArea:SetVisible(false)

	function self.Slider:Paint(intW, intH)
		draw.RoundedBox(4, 0, intH *.5 -3, intW, 6, Color(50, 50, 50))
	end
	function self.Slider.Knob:Paint(intW, intH)
		draw.RoundedBox(16, 0, 0, 16, 16, Color(100, 100, 100))
	end

	self.pnlIndicator = vgui.Create("DPanel", self)
	self.pnlIndicator:Dock(BOTTOM)
	self.pnlIndicator:SetTall(30)
	function self.pnlIndicator:Paint(intW, intH)
		local strValue = (self:GetParent().strValueTitle or "Value").. ": ".. self:GetParent().TextArea:GetText().. "px"
		surface.SetFont("Seth:Area:Purista:18:Italic")
		local intWeightValue = select(1, surface.GetTextSize(strValue))

		draw.RoundedBox(8, 0, 0, intWeightValue +20, intH, Color(50, 50, 50))
		draw.SimpleText( strValue, "Seth:Area:Purista:18:Italic", 10, intH *.5, Color(150, 150, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function PANEL:SetValueTitle(strValueTitle)
	self.strValueTitle = strValueTitle
end

vgui.Register("SethArea_Slider", PANEL, "DNumSlider")

