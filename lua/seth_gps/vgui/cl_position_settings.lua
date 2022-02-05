--[[
    name: cl_position_settings.lua
]]--

local PANEL = {}

function PANEL:Init()
    self:SetTitle("Position settings")
    self:DockPadding(0, 50, 0, 0)
    self:SetSize(500, 310)
    self:MakePopup()

    self.pnlXCoorinateLabel = vgui.Create("DLabel", self)
    self.pnlXCoorinateLabel:Dock(TOP)
    self.pnlXCoorinateLabel:DockMargin(10, 10, 10, 0)
    self.pnlXCoorinateLabel:SetText("X Coordinate")
    self.pnlXCoorinateLabel:SetFont("Seth:Area:Purista:18:Italic")
    self.pnlXCoorinateLabel:SetTextColor(Color(180, 180, 180))

    self.pnlXCoorinateSlider = vgui.Create("SethArea_Slider", self)
    self.pnlXCoorinateSlider:Dock(TOP)
    self.pnlXCoorinateSlider:DockMargin(10, 0, 10, 0)
    self.pnlXCoorinateSlider:SetTall(70)
    self.pnlXCoorinateSlider:SetMin(0)
    self.pnlXCoorinateSlider:SetMax(ScrW() -260)
    self.pnlXCoorinateSlider:SetValue(GetConVar("seth_gps_x"):GetInt())
    function self.pnlXCoorinateSlider:OnValueChanged(intValue)
        local pnlToMove = self:GetParent().pnlToMove
        if !pnlToMove then return end
        pnlToMove:SetPos(intValue, select(2, pnlToMove:GetPos()))
    end

    self.pnlYCoorinateLabel = vgui.Create("DLabel", self)
    self.pnlYCoorinateLabel:Dock(TOP)
    self.pnlYCoorinateLabel:DockMargin(10, 20, 10, 0)
    self.pnlYCoorinateLabel:SetText("Y Coordinate")
    self.pnlYCoorinateLabel:SetFont("Seth:Area:Purista:18:Italic")
    self.pnlYCoorinateLabel:SetTextColor(Color(180, 180, 180))

    self.pnlYCoorinateSlider = vgui.Create("SethArea_Slider", self)
    self.pnlYCoorinateSlider:Dock(TOP)
    self.pnlYCoorinateSlider:DockMargin(10, 0, 10, 0)
    self.pnlYCoorinateSlider:SetTall(70)
    self.pnlYCoorinateSlider:SetMin(0)
    self.pnlYCoorinateSlider:SetMax(ScrH() /2)
    self.pnlYCoorinateSlider:SetValue(GetConVar("seth_gps_y"):GetInt())
    function self.pnlYCoorinateSlider:OnValueChanged(intValue)
        local pnlToMove = self:GetParent().pnlToMove
        if !pnlToMove then return end
        pnlToMove:SetPos(select(1, pnlToMove:GetPos()), intValue)
    end

    self.pnlSaveBtn = vgui.Create("SethArea_Button", self)
    self.pnlSaveBtn:Dock(BOTTOM)
    self.pnlSaveBtn:SetTall(35)
    self.pnlSaveBtn:SetButtonText("Save")
	self.pnlSaveBtn:SetRounded(16, false, false, true, true)
	self.pnlSaveBtn:SetBackgroundColor(Color(35, 155, 86))
	self.pnlSaveBtn:SetBackgroundHoveredColor(Color(40, 170, 100))
    function self.pnlSaveBtn:DoClick()
        local intX, intY = self:GetParent().pnlXCoorinateSlider:GetValue(), self:GetParent().pnlYCoorinateSlider:GetValue()

        GetConVar("seth_gps_x"):SetInt(intX)
        GetConVar("seth_gps_y"):SetInt(intY)

        local pPlayer = LocalPlayer()
        local pnlGPS = pPlayer["SA_GPS_PANEL"]
        if pnlGPS and ValidPanel(pnlGPS) then pnlGPS:Remove() end
        pPlayer["SA_GPS_PANEL"] = vgui.Create("SethArea_GPS")
        pPlayer["SA_GPS_PANEL"]:SetPos(intX, intY) 

        local pnlParent = self:GetParent():GetParent()
		if !pnlParent then return end
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
		local pnlParent = self:GetParent():GetParent()
		if !pnlParent then return end
		pnlParent:Remove()
	end
end

function PANEL:SetPanelToMove(pnlToMove)
    self.pnlToMove = pnlToMove
end

vgui.Register("SethArea_Position", PANEL, "SethArea_Frame")

local PANEL = {}

function PANEL:Init()
    self:Dock(FILL)

    self.pnlShadow = vgui.Create("SethArea_Frame", self)
    self.pnlShadow:SetSize(260, ScrH() *.5)
    self.pnlShadow:SetPos(GetConVar("seth_gps_x"):GetInt(), GetConVar("seth_gps_y"):GetInt())
    self.pnlShadow:SetTitle("Exemple")

    self.pnlPosition = vgui.Create("SethArea_Position", self)
    self.pnlPosition:SetPanelToMove(self.pnlShadow)
end

function PANEL:PerformLayout()
    self.pnlPosition:SetPos(self:GetWide() *.5 -self.pnlPosition:GetWide() *.5, self:GetTall() *.5 -self.pnlPosition:GetTall() *.5)
end 

function PANEL:Paint(intW, intH)
    Derma_DrawBackgroundBlur(self)
end

vgui.Register("SethArea_ShadowFrame", PANEL, "DPanel")
