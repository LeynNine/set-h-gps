--[[
	name: cl_hook.lua
]]--

-- Called before all the translucent entities are drawn. 
hook.Add( "PreDrawTranslucentRenderables", "HOOK:Seth:Area:PreDrawOpaqueRenderables", function( bolIsDrawingDepth, bolIsDrawSkybox  )																																																																														--[[ 76561198180318085 ]]--
	local pPlayer = LocalPlayer()
	if !pPlayer then return end

	Seth.Area.DRAW:Points3D()
end)

-- Called whenever the HUD should be drawn.
hook.Add( "HUDPaint", "HOOK:Seth:Area:HUDPaint", function()
	local pPlayer = LocalPlayer()
	if !pPlayer then return end

	Seth.Area.DRAW:Points2D()
	if pPlayer[ "SA_MOD" ] then
		Seth.Area.DRAW:HUDPaint()
	end
end)

-- Called when a player dispatched a chat message.
hook.Add("OnPlayerChat", "HOOK:Seth:Area:OnPlayerChat", function(pPlayer, strText, bolTeam, bolIsDead)
	if pPlayer == LocalPlayer() then
		if string.sub(string.lower(strText), 1, string.len(Seth.Area.CONFIG.CommandToDisplayGPS)) == Seth.Area.CONFIG.CommandToDisplayGPS then
			if pPlayer["SA_GPS_PANEL"] then
				pPlayer["SA_GPS_PANEL"]:SetVisible(!pPlayer["SA_GPS_PANEL"]:IsVisible())
			else
				pPlayer[ "SA_GPS_PANEL" ] = vgui.Create( "SethArea_GPS" )
				pPlayer[ "SA_GPS_PANEL" ]:SetPos(GetConVar("seth_gps_x"):GetInt(), GetConVar("seth_gps_y"):GetInt())
			end		
		end
	end
end)

// Called every frame on client and every tick on server.
hook.Add( "Think", "HOOK:Seth:Area:Think", function()
	Seth.Area.NOTIFY:UpdateNotify()
end)

// Called after all the entities are initialized. 
hook.Add( "InitPostEntity", "HOOK:Seth:Area:InitPostEntity", function()
	local pPlayer = LocalPlayer()
	if !pPlayer then return end

	if !Seth.Area.DRAW.tblPoints or table.Count( Seth.Area.DRAW.tblPoints ) <1 then return end
	pPlayer[ "SA_GPS_PANEL" ] = vgui.Create( "SethArea_GPS" )
	pPlayer[ "SA_GPS_PANEL" ]:SetPos(GetConVar("seth_gps_x"):GetInt(), GetConVar("seth_gps_y"):GetInt())
end)
