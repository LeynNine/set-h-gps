--[[
    name: sv_notify.lua
]]--

local NOTIFY = {}

// Sends a notification to the client side
function NOTIFY:AddNotify(pPlayer, strText, bolType, intLength)
    net.Start( "NET:Seth:Area" )
        net.WriteUInt( 7, 8 )
        net.WriteTable({strText, bolType, intLength})
    net.Send( pPlayer )
end

Seth.Area.NOTIFY = NOTIFY
