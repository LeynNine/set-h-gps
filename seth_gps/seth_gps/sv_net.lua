--[[
	name: sv_net.lua
]]--

// Adds the specified string to a string table
util.AddNetworkString("NET:Seth:Area")

// Adds a position in the DATA and sends it to the client side
local function AddPosition(pPlayer, vecPos, tblPosition) 
	if !istable(tblPosition) then return end
	if !tblPosition.Name or !isstring(tblPosition.Name) or tblPosition.Name == "" then
		return Seth.Area.NOTIFY:AddNotify(pPlayer, Seth.Area.LANGUAGE:Get("NOTIFY:InvalidName"), true, 5)
	end
	if !tblPosition.Desc or !isstring(tblPosition.Desc) or tblPosition.Desc == "" then
		return Seth.Area.NOTIFY:AddNotify(pPlayer, Seth.Area.LANGUAGE:Get("NOTIFY:InvalidVector"), true, 5)
	end
	
	if !tblPosition.Color or !istable(tblPosition.Color) then
		return Seth.Area.NOTIFY:AddNotify(pPlayer, Seth.Area.LANGUAGE:Get("NOTIFY:InvalidColor"), true, 5)
	end
	local bolCallBack = Seth.Area.DATA:AddPoint(pPlayer, tblPosition.Name, tblPosition.Desc, tblPosition.Color, vecPos)
	
	if !bolCallBack then return end

	net.Start("NET:Seth:Area")
		net.WriteUInt(4, 8)
			net.WriteTable({
				Name 	= tblPosition.Name, 
				Desc 	= tblPosition.Desc, 
				Color 	= tblPosition.Color, 
				Vector 	= vecPos
			})
	net.Broadcast()
end

// Deletes a position in the DATA and on the client side
local function RemovePosition(pPlayer, vecPos)
	local bolCallBack, strName = Seth.Area.DATA:RemovePoint(pPlayer, vecPos)
	
	if !strName then return end
	if !bolCallBack then return end
	
	net.Start("NET:Seth:Area")
		net.WriteUInt(5, 8)
			net.WriteString(strName)
	net.Broadcast()
end

// The main NET function
net.Receive("NET:Seth:Area", function(_, pPlayer)
	local intU = net.ReadUInt(8)
	local vecPos = pPlayer:GetEyeTrace().HitPos
	
	if !pPlayer then return end
	if !pPlayer["SA_MOD"] or !pPlayer:IsSuperAdmin() then 
		Seth.Area.NOTIFY:AddNotify(pPlayer, "You are not on SA mod, switch with the command '".. Seth.Area.CONFIG.CommandToSwapOnAdminMode.. "'", 0, 5)
		return 
	end
	if !intU or !isnumber(intU) then return end
	if !vecPos or !isvector(vecPos) then 
		Seth.Area.NOTIFY:AddNotify(pPlayer, Seth.Area.LANGUAGE:Get("NOTIFY:InvalidVector"), 0, 5)
		return 
	end

	if intU == 2 then
		AddPosition(pPlayer, vecPos, net.ReadTable()) 
	elseif intU == 3 then
		RemovePosition(pPlayer, vecPos)
	end
end)
