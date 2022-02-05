--[[
	Name: cl_notify.lua
	Credit: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/modules/notification.lua
]]--

local NOTIFY = {}
NOTIFY.tblNotify = NOTIFY.tblNotify or {}

function NOTIFY:AddNotify( strText, bolType, intLength )
	local bolReverse = GetConVar("seth_gps_x"):GetInt() < ScrW() *.5 and true or false

	local pnlNotify = vgui.Create( "SethArea_Notify" )
	pnlNotify.intStartTime = SysTime()
	pnlNotify.intLength = intLength
	pnlNotify.intVelocityX = 5
	pnlNotify.intVelocityY = 0
	pnlNotify.intFadeX = bolReverse and ScrW() +pnlNotify:GetWide() *2 or -200
	pnlNotify.intFadeY = 10
	pnlNotify.bolReverse = bolReverse
	pnlNotify:SetText( strText )
	pnlNotify:SetPos( pnlNotify.intFadeX, pnlNotify.intFadeY )
	pnlNotify:SetType( bolType )

	table.insert( self.tblNotify, pnlNotify )
end

local function Update( pnlNotify, intTotalH )
	local intX, intY = pnlNotify.intFadeX, pnlNotify.intFadeY
	local intWeight, intHeight = pnlNotify:GetWide() +16, pnlNotify:GetTall() +4
	local intIdealY, intIdealX = 10 +intTotalH, pnlNotify.bolReverse and ScrW() -intWeight -5 or 5
	local intTimeLeft = pnlNotify.intStartTime -( SysTime() -pnlNotify.intLength )

	if intTimeLeft < .2 then
		intIdealX = pnlNotify.bolReverse and intIdealX +( intWeight *2 ) or intIdealX -( intWeight *2 )
	end

	local intSPD = RealFrameTime() *15
	intY, intX = intY +pnlNotify.intVelocityY *intSPD, intX +pnlNotify.intVelocityX *intSPD
	local intDistance = intIdealY -intY
	pnlNotify.intVelocityY = pnlNotify.intVelocityY +intDistance *intSPD *1
	
	if ( math.abs( intDistance ) < 2 and math.abs( pnlNotify.intVelocityY ) < 0.1 ) then pnlNotify.intVelocityY = 0 end
	intDistance = intIdealX - intX
	pnlNotify.intVelocityX = pnlNotify.intVelocityX +intDistance *intSPD *1
	
	if ( math.abs( intDistance ) < 2 and math.abs( pnlNotify.intVelocityX ) < 0.1 ) then pnlNotify.intVelocityX = 0 end
	pnlNotify.intVelocityX = pnlNotify.intVelocityX *( 0.95 -RealFrameTime() *8 )
	pnlNotify.intVelocityY = pnlNotify.intVelocityY *( 0.95 -RealFrameTime() *8 )

	pnlNotify.intFadeX = intX
	pnlNotify.intFadeY = intY
	if ( intIdealY > -ScrH() ) then
		pnlNotify:SetPos( pnlNotify.intFadeX, pnlNotify.intFadeY )
	end

	return intTotalH +intHeight
end

function NOTIFY:UpdateNotify()
	if ( !self.tblNotify ) then return end

	local intH = 0
	for intIndex, pnlNotify in pairs( self.tblNotify ) do
		intH = Update( pnlNotify, intH )
	end

	for intIndex, pnlNotify in pairs( self.tblNotify ) do
		if ( !IsValid( pnlNotify ) or pnlNotify:KillSelf() ) then self.tblNotify [ intIndex ] = nil end																																																																						--[[ 76561198180318085 ]]--
	end
end

Seth.Area.NOTIFY = NOTIFY