--[[
	name: sv_hook.lua
]]--

-- Called after the gamemode loads and starts. 
hook.Add("Initialize", "HOOK:Seth:Area:Initialize", function()
	Seth.Area.DATA:CreateFiles()
end)

-- Called when a player dispatched a chat message.
hook.Add("PlayerSay", "HOOK:Seth:Area:PlayerSay", function(pSender, strText, bolTeamChat)
	if string.sub(string.lower(strText), 1, string.len(Seth.Area.CONFIG.CommandToSwapOnAdminMode)) == Seth.Area.CONFIG.CommandToSwapOnAdminMode then
		if !pSender or !pSender:IsSuperAdmin() then return end
		pSender["SA_MOD"] = pSender["SA_MOD"] or false
		pSender["SA_MOD"] = !pSender["SA_MOD"]

		net.Start("NET:Seth:Area")
			net.WriteUInt(1, 8)
				net.WriteBool(pSender["SA_MOD"])
		net.Send(pSender)

		return ""
	end
end)

-- Called whenever a player pressed a key included within the IN keys.
hook.Add("KeyPress", "HOOK:Seth:Area:KeyPress", function(pPlayer, intKey)
	if !pPlayer:IsSuperAdmin() or !pPlayer["SA_MOD"] then return end
	if intKey == IN_ATTACK then
		net.Start("NET:Seth:Area")
			net.WriteUInt(2, 8)
		net.Send(pPlayer)
	elseif intKey == IN_ATTACK2 then
		net.Start("NET:Seth:Area")
			net.WriteUInt(3, 8)
		net.Send(pPlayer)
	end
end)

-- Called when the player spawns for the first time.
hook.Add("PlayerInitialSpawn", "HOOK:Seth:Area:PlayerInitialSpawn", function(pPlayer)
	if !pPlayer then return end

	local tblPoints = Seth.Area.DATA:GetFileContent("gps.txt")
	local tblGPSPos = Seth.Area.DATA:GetFileContent("gps_position.txt")
	if !tblPoints or table.Count(tblPoints) < 1 then return end
	
	net.Start("NET:Seth:Area")
		net.WriteUInt(6, 8)
			net.WriteTable(tblPoints)
			net.WriteTable(tblGPSPos)
	net.Send(pPlayer)
end)
