--[[
	name: cl_create.lua
]]--

--[[ --
	Name: Color mixer panel
-- ]]--

local PANEL = {}

function PANEL:Init()
	self:SetSize(300, 350)
	self:SetTitle("Custom color")
	self:DockPadding( 0, 65, 0, 0 )

	self.pnlColorMixer = vgui.Create( "DColorMixer", self )
	self.pnlColorMixer:Dock(FILL)
	self.pnlColorMixer:DockMargin(15, 0, 15, 15)
	self.pnlColorMixer:SetAlphaBar(false)

	self.pnlSelectBtn = vgui.Create( "SethArea_Button", self )
	self.pnlSelectBtn:Dock(BOTTOM)
	self.pnlSelectBtn:SetSize(0, 30)
	self.pnlSelectBtn:SetButtonText( "Select" )
	self.pnlSelectBtn:SetRounded( 16, false, false, true, true )
	self.pnlSelectBtn:SetBackgroundColor( Color( 26, 82, 118 ) )
	self.pnlSelectBtn:SetBackgroundHoveredColor( Color( 36, 110, 157 ) )
	function self.pnlSelectBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
	
		local pnlReceiver = pnlParent.pnlReceiver
		local pnlIndicator = pnlParent.pnlIndicator
		if pnlReceiver or pnlReceiver.colReturn then
			local colReturn = pnlParent.pnlColorMixer:GetColor()
			pnlReceiver.colReturn = colReturn
			pnlIndicator:SetBackgroundColor(colReturn)
		end
		pnlParent:Remove()
	end

	self.pnlRemoveBtn = vgui.Create( "DButton", self )
	self.pnlRemoveBtn:SetSize( 50, 50 )
	self.pnlRemoveBtn:SetPos( self:GetWide() -self.pnlRemoveBtn:GetWide(), 0 )
	self.pnlRemoveBtn:SetText( "✕" )
	self.pnlRemoveBtn:SetFont( "Seth:Area:Purista:22" )
	self.pnlRemoveBtn:SetTextColor( Color( 150, 150, 150 ) )
	function self.pnlRemoveBtn:Paint() end
	function self.pnlRemoveBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		pnlParent:Remove()
	end
end

function PANEL:SetColorReceiver( pnlReceiver )
	self.pnlReceiver = pnlReceiver
end

function PANEL:SetColorIndicator( pnlIndicator )
	self.pnlIndicator = pnlIndicator
end

vgui.Register( "SethArea_ColorMixerPanel", PANEL, "SethArea_Frame")

--[[ --
	Name: Color panel
-- ]]--

local PANEL = {}

function PANEL:Init()
	self.pnlRedBtn = vgui.Create( "DButton", self )
	self.pnlRedBtn:SetText( "" )
	self.pnlRedBtn:SetFont( "Seth:Area:Purista:16:Italic" )
	self.pnlRedBtn:SetColor( Color( 255, 255, 255 ) )
	self.pnlRedBtn.bolIsSelected = false
	function self.pnlRedBtn:Paint( intW, intH )
		surface.SetDrawColor( Seth.Area.CONFIG.FirstPointColor )
		surface.DrawRect( 0, 0, intW, intH )

		if self.Hovered then
			surface.SetDrawColor( Color( 255, 255, 255, 30 ) )
			surface.DrawRect( 0, 0, intW, intH )
		end

		if self.bolIsSelected then
			surface.SetDrawColor( 255, 255, 255  )
		else
			surface.SetDrawColor( 30, 30, 30 )
		end
		surface.DrawOutlinedRect( 0, 0, intW, intH )
	end
	function self.pnlRedBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		pnlParent.colReturn = Seth.Area.CONFIG.FirstPointColor

		self.bolIsSelected = true
		pnlParent.pnlOrangeBtn.bolIsSelected = false
		pnlParent.pnlYellowBtn.bolIsSelected = false
		pnlParent.pnlBlueBtn.bolIsSelected = false
	end

	self.pnlOrangeBtn = vgui.Create( "DButton", self )
	self.pnlOrangeBtn:SetText( "" )
	self.pnlOrangeBtn:SetFont( "Seth:Area:Purista:16:Italic" )
	self.pnlOrangeBtn:SetColor( Color( 255, 255, 255 ) )
	self.pnlOrangeBtn.bolIsSelected = false
	function self.pnlOrangeBtn:Paint( intW, intH )
		surface.SetDrawColor( Seth.Area.CONFIG.SecondPointColor )
		surface.DrawRect( 0, 0, intW, intH )

		if self.Hovered then
			surface.SetDrawColor( Color( 255, 255, 255, 30 ) )
			surface.DrawRect( 0, 0, intW, intH )
		end

		if self.bolIsSelected then
			surface.SetDrawColor( 255, 255, 255 )
		else
			surface.SetDrawColor( 30, 30, 30 )
		end
		surface.DrawOutlinedRect( 0, 0, intW, intH )
	end
	function self.pnlOrangeBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		pnlParent.colReturn = Seth.Area.CONFIG.SecondPointColor

		self.bolIsSelected = true
		pnlParent.pnlRedBtn.bolIsSelected = false
		pnlParent.pnlYellowBtn.bolIsSelected = false
		pnlParent.pnlBlueBtn.bolIsSelected = false
	end

	self.pnlYellowBtn = vgui.Create( "DButton", self )
	self.pnlYellowBtn:SetText( "" )
	self.pnlYellowBtn:SetFont( "Seth:Area:Purista:16:Italic" )
	self.pnlYellowBtn:SetColor( Color( 255, 255, 255 ) )
	self.pnlYellowBtn.bolIsSelected = false
	function self.pnlYellowBtn:Paint( intW, intH )
		surface.SetDrawColor( Seth.Area.CONFIG.ThirdPointColor )
		surface.DrawRect( 0, 0, intW, intH )

		if self.Hovered then
			surface.SetDrawColor( Color( 255, 255, 255, 30 ) )
			surface.DrawRect( 0, 0, intW, intH )
		end

		if self.bolIsSelected then
			surface.SetDrawColor( 255, 255, 255  )
		else
			surface.SetDrawColor( 30, 30, 30 )
		end
		surface.DrawOutlinedRect( 0, 0, intW, intH )
	end
	function self.pnlYellowBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		pnlParent.colReturn = Seth.Area.CONFIG.ThirdPointColor

		self.bolIsSelected = true
		pnlParent.pnlOrangeBtn.bolIsSelected = false
		pnlParent.pnlRedBtn.bolIsSelected = false
		pnlParent.pnlBlueBtn.bolIsSelected = false
	end

	self.pnlBlueBtn = vgui.Create( "DButton", self )
	self.pnlBlueBtn:SetText( "" )
	self.pnlBlueBtn:SetFont( "Seth:Area:Purista:16:Italic" )
	self.pnlBlueBtn:SetColor( Color( 255, 255, 255 ) )
	self.pnlBlueBtn.bolIsSelected = false
	function self.pnlBlueBtn:Paint( intW, intH )
		surface.SetDrawColor( Seth.Area.CONFIG.FourthPointColor )
		surface.DrawRect( 0, 0, intW, intH )

		if self.Hovered then
			surface.SetDrawColor( Color( 255, 255, 255, 30 ) )
			surface.DrawRect( 0, 0, intW, intH )
		end

		if self.bolIsSelected then
			surface.SetDrawColor( 255, 255, 255  )
		else
			surface.SetDrawColor( 30, 30, 30 )
		end
		surface.DrawOutlinedRect( 0, 0, intW, intH )
	end
	function self.pnlBlueBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		pnlParent.colReturn = Seth.Area.CONFIG.FourthPointColor

		self.bolIsSelected = true
		pnlParent.pnlOrangeBtn.bolIsSelected = false
		pnlParent.pnlYellowBtn.bolIsSelected = false
		pnlParent.pnlRedBtn.bolIsSelected = false
	end

	self.pnlCustomColorBtn = vgui.Create("SethArea_Button", self)
	self.pnlCustomColorBtn:SetButtonText("Custom Color")
	self.pnlCustomColorBtn:SetRounded(16, true, true, true, true)
	self.pnlCustomColorBtn:SetBackgroundColor(Color(185, 119, 14))
	self.pnlCustomColorBtn:SetBackgroundHoveredColor(Color(214, 137, 16))	
	function self.pnlCustomColorBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end

		self.pnlCustomColorMixer = vgui.Create("SethArea_ColorMixerPanel")
		self.pnlCustomColorMixer:SetPos( ScrW() *.5 +pnlParent:GetWide() *.5 +25, ScrH() *.5 -pnlParent:GetTall() *.5 -self.pnlCustomColorMixer:GetTall() *.5 -5)
		self.pnlCustomColorMixer:SetColorReceiver(pnlParent)
		self.pnlCustomColorMixer:SetColorIndicator( self )
	end
end

function PANEL:OnRemove()
	if self.pnlCustomColorBtn and self.pnlCustomColorBtn.pnlCustomColorMixer then
		self.pnlCustomColorBtn.pnlCustomColorMixer:Remove()
	end
end

function PANEL:GetColor()
	return self.colReturn or Color( 255, 255, 255 )
end

function PANEL:PerformLayout( intW, intH )
	self.pnlRedBtn:SetSize( intW *.25 -6, intH -40 )
	self.pnlRedBtn:SetPos( 0, 40 )

	self.pnlOrangeBtn:SetSize( intW *.25 -6, intH -40 )
	self.pnlOrangeBtn:SetPos( intW *.25 +2, 40 )

	self.pnlYellowBtn:SetSize( intW *.25 -6, intH -40 )
	self.pnlYellowBtn:SetPos( ( intW *.25 +2 ) *2, 40 )

	self.pnlBlueBtn:SetSize( intW *.25 -6, intH -40 )
	self.pnlBlueBtn:SetPos( ( intW *.25 +2 ) *3, 40 )

	self.pnlCustomColorBtn:SetSize( intW, 30 )
end

function PANEL:Paint() end

vgui.Register( "SethArea_ColorPanel", PANEL, "DPanel" )

local PANEL = {}

function PANEL:Init()
	self:SetSize( 400, 450 )
	self:Center()
	self:SetTitle( Seth.Area.LANGUAGE:Get( "VGUI:CreatePanelTitle" ) )
	self:MakePopup()

	-- Label
	self.pnlNameLabel = vgui.Create( "DLabel", self )
	self.pnlNameLabel:SetSize( self:GetWide() -30, 20 )
	self.pnlNameLabel:SetPos( 15, 65 )
	self.pnlNameLabel:SetText( Seth.Area.LANGUAGE:Get( "VGUI:CreatePanelName" ) )
	self.pnlNameLabel:SetContentAlignment( 7 )
	self.pnlNameLabel:SetFont( "Seth:Area:Purista:18:Italic" )
	self.pnlNameLabel:SetColor( Color( 150, 150, 150 ) )

	self.pnlDescLabel = vgui.Create( "DLabel", self )
	self.pnlDescLabel:SetSize( self:GetWide() -30, 20 )
	self.pnlDescLabel:SetPos( 15, 140 )
	self.pnlDescLabel:SetText( Seth.Area.LANGUAGE:Get( "VGUI:CreatePanelDesc" ) )
	self.pnlDescLabel:SetContentAlignment( 7 )
	self.pnlDescLabel:SetFont( "Seth:Area:Purista:18:Italic" )
	self.pnlDescLabel:SetColor( Color( 150, 150, 150 ) )

	self.pnlColorLabel = vgui.Create( "DLabel", self )
	self.pnlColorLabel:SetSize( self:GetWide() -30, 20 )
	self.pnlColorLabel:SetPos( 15, 285 )
	self.pnlColorLabel:SetText( Seth.Area.LANGUAGE:Get( "VGUI:CreatePanelColor" ) )
	self.pnlColorLabel:SetContentAlignment( 7 )
	self.pnlColorLabel:SetFont( "Seth:Area:Purista:18:Italic" )
	self.pnlColorLabel:SetColor( Color( 150, 150, 150 ) )

	-- Custom
	self.pnlNameTe = vgui.Create( "SethArea_TextEntry", self )
	self.pnlNameTe:SetSize( self:GetWide() -30, 24 )
	self.pnlNameTe:SetPos( 15, 95 )
	self.pnlNameTe:SetPlaceHolderText( Seth.Area.LANGUAGE:Get( "VGUI:CreatePanelTextEntryName" ) )

	self.pnlDescTe = vgui.Create( "SethArea_TextEntry", self )
	self.pnlDescTe:SetSize( self:GetWide() -30, 100 )
	self.pnlDescTe:SetMultiline( true )
	self.pnlDescTe:SetPos( 15, 170 )
	self.pnlDescTe:SetPlaceHolderText( Seth.Area.LANGUAGE:Get( "VGUI:CreatePanelTextEntryDesc" ) )

	self.pnlColor = vgui.Create( "SethArea_ColorPanel", self )
	self.pnlColor:SetSize( self:GetWide() -30, 95 )
	self.pnlColor:SetPos( 15, 315 )

	--Btn
	self.pnlRemoveBtn = vgui.Create( "DButton", self )
	self.pnlRemoveBtn:SetSize( 50, 50 )
	self.pnlRemoveBtn:SetPos( self:GetWide() -self.pnlRemoveBtn:GetWide(), 0 )
	self.pnlRemoveBtn:SetText( "✕" )
	self.pnlRemoveBtn:SetFont( "Seth:Area:Purista:22" )
	self.pnlRemoveBtn:SetTextColor( Color( 150, 150, 150 ) )
	function self.pnlRemoveBtn:Paint() end
	function self.pnlRemoveBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end
		pnlParent:Remove()
	end

	self.pnlCreateBtn = vgui.Create( "SethArea_Button", self )
	self.pnlCreateBtn:SetSize( self:GetWide(), 30 )
	self.pnlCreateBtn:SetPos( 0, self:GetTall() -self.pnlCreateBtn:GetTall() )
	self.pnlCreateBtn:SetButtonText( "Create" )
	self.pnlCreateBtn:SetRounded( 16, false, false, true, true )
	self.pnlCreateBtn:SetBackgroundColor( Color( 26, 82, 118 ) )
	self.pnlCreateBtn:SetBackgroundHoveredColor( Color( 36, 110, 157 ) )
	function self.pnlCreateBtn:DoClick()
		local pnlParent = self:GetParent()
		if !pnlParent then return end

		local strName, strDesc, colColor = pnlParent.pnlNameTe:GetText(),
										pnlParent.pnlDescTe:GetText() != "" and pnlParent.pnlDescTe:GetText() or Seth.Area.LANGUAGE:Get( "VGUI:CreatePanelNoDesc" ),
										pnlParent.pnlColor:GetColor()

		
		if !strName == ""  or strDesc == "" or !colColor then return end

		net.Start( "NET:Seth:Area" )
			net.WriteUInt( 2, 8 )
				net.WriteTable( {
					Name = strName,
					Desc = strDesc,
					Color = colColor
				})
		net.SendToServer()

		pnlParent:Remove()
	end
end

vgui.Register( "SethArea_CreatePointPanel", PANEL, "SethArea_Frame" )
