--[[
	name: cl_net.lua
]]--

// Define whether or not the user goes into admin mode
local function SetMode(pPlayer, bolMode)
	pPlayer["SA_MOD"] = bolMode

	if bolMode then 
		Seth.Area.NOTIFY:AddNotify(Seth.Area.LANGUAGE:Get("NOTIFY:EnterAdminMode"), true, 5)
	else
		Seth.Area.NOTIFY:AddNotify(Seth.Area.LANGUAGE:Get("NOTIFY:QuitAdminMode"), true, 5)
	end
	
	Seth.Area.DRAW:ResetCheckbox()
end

// Opens the point creator menu
local function OpenCreatePointMenu(pPlayer)
	if !pPlayer["SA_MOD"] or !pPlayer:IsSuperAdmin() then return end
	vgui.Create("SethArea_CreatePointPanel")
end

// Opens the validation menu to accept or not the deletion of a position
local function OpenValidMenu(pPlayer, intU)
	if !pPlayer["SA_MOD"] or !pPlayer:IsSuperAdmin() then return end

	local pnlValid = vgui.Create("SethArea_ValidPanel")
	pnlValid:SetText(Seth.Area.LANGUAGE:Get("VGUI:DeletePoint"))
	pnlValid:SetNetID(intU)
end

// Adds a new position to send from the server side
local function AddPosition(pPlayer, tblPositions)
	if !tblPositions or !istable(tblPositions) then return end
	
	Seth.Area.DRAW.tblPoints[tblPositions.Name] = {
		Vector 	= tblPositions.Vector,
		Desc 	= tblPositions.Desc,
		Color 	= tblPositions.Color
	}

	local pnlGPS = pPlayer["SA_GPS_PANEL"]
	if pnlGPS and ValidPanel(pnlGPS) then pnlGPS:Remove() end
	pPlayer["SA_GPS_PANEL"] = vgui.Create("SethArea_GPS")
	pPlayer["SA_GPS_PANEL"]:SetPos(GetConVar("seth_gps_x"):GetInt(), GetConVar("seth_gps_y"):GetInt())
end

// Remove an position
local function RemovePosition(pPlayer, strPosition)
	local tblDraw = Seth.Area.DRAW.tblPoints
	local pnlGPS = pPlayer["SA_GPS_PANEL"]

	if !strPosition or !isstring(strPosition) then return end
	if !tblDraw or !tblDraw[strPosition] then return end
	Seth.Area.DRAW.tblPoints[strPosition] = nil

	if pnlGPS and ValidPanel(pnlGPS) then pnlGPS:Remove() end
	if table.Count(tblDraw) <1 then return end
	pPlayer["SA_GPS_PANEL"] = vgui.Create("SethArea_GPS")
	pPlayer["SA_GPS_PANEL"]:SetPos(GetConVar("seth_gps_x"):GetInt(), GetConVar("seth_gps_y"):GetInt())
end

// Update client-side positions
local function UpdatePosition(pPlayer, tblPosition)
	if !tblPosition then return end
	Seth.Area.DRAW.tblPoints = tblPosition
end

// Displays notifications of the server side
local function AddNotify(tblNotify)
	if !tblNotify then return end
	Seth.Area.NOTIFY:AddNotify(tblNotify[1], tblNotify[2], tblNotify[3])
end

// The main NET function
net.Receive("NET:Seth:Area", function()
	local intU = net.ReadUInt(8)
	local pPlayer = LocalPlayer()
	if !pPlayer then return end

	if intU == 1 then
		SetMode(pPlayer, net.ReadBool())
	elseif intU == 2 then
		OpenCreatePointMenu(pPlayer)
	elseif intU == 3 then
		OpenValidMenu(pPlayer, intU)
	elseif intU == 4 then
		AddPosition(pPlayer, net.ReadTable())
	elseif intU == 5 then
		RemovePosition(pPlayer, net.ReadString())
	elseif intU == 6 then
		UpdatePosition(pPlayer, net.ReadTable())
	elseif intU == 7 then
		AddNotify(net.ReadTable())
	end
end)

function NET( intIndex )
	
end

