--[[
	name: sh_config.lua
]]--

Seth.Area.CONFIG = Seth.Area.CONFIG or {}
local CONFIG = Seth.Area.CONFIG

-- Language
CONFIG.Language = "EN" -- The language you want you use ( EN = English, FR = French, PL = Polish, RU = Russian, DK = Danish, DE = German, CN = Chinese )

CONFIG.FastDL = true -- If you want your players not to need to subscribe to the workshop

CONFIG.FirstPointColor  = Color( 203, 67, 53 ) -- First color avaible in a menu to create a point
CONFIG.SecondPointColor = Color( 212, 172, 13 ) -- Second color avaible in a menu to create a point
CONFIG.ThirdPointColor = Color( 241, 196, 15 ) -- Third color avaible in a menu to create a point
CONFIG.FourthPointColor = Color( 46, 134, 193 ) -- Fourth color avaible in a menu to create a point

CONFIG.MenuIsOpenOnSpawn = true -- Define if the menu is open to the player's spawn
CONFIG.DistanceToTransformPoint = 30 -- The distance at which the point changes shape
CONFIG.DistanceToRemovePoint = 4 -- The distance at which the point disappears

CONFIG.CommandToSwapOnAdminMode = "/sa_mode" -- The command to configure the addon
CONFIG.CommandToDisplayGPS = "/gps" -- The command to display or disappear the GPS













