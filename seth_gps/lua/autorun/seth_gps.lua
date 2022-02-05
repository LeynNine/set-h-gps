--[[
	name: seth_area.lua
]]--

Seth = Seth or {}
Seth.Area = Seth.Area or {}

function Seth.Area:Print( ... )
    return MsgC( Color( 255, 0, 0 ), "[ Seth - Area ]", Color( 255, 200, 0 ), ..., "\n" )
end

function Seth.Area:IncludeFile( strFileName )
    if strFileName:find( "sh_" ) then
        if strFileName == "sh_config.lua" then return end
        if SERVER then AddCSLuaFile( strFileName ) end
        include( strFileName )
    elseif SERVER and strFileName:find( "sv_" ) then
        include( strFileName )
    elseif strFileName:find( "cl_" ) then
        if SERVER then AddCSLuaFile( strFileName ) end
        if CLIENT then include( strFileName ) end
    end
end

function Seth.Area:IncludeFolder( strFolderName )
    local tblFiles, tblFolders = file.Find( strFolderName.. "*", "LUA" )

    -- Add config file
    AddCSLuaFile( "seth_gps/sh_config.lua" )
    include( "seth_gps/sh_config.lua" )

    for _, strFile in ipairs( tblFiles ) do
        Seth.Area:Print( "[ FILE LOADED ] ".. strFile )
        Seth.Area:IncludeFile( strFolderName.. strFile )
    end

    for _, strFolder in ipairs( tblFolders ) do
        Seth.Area:IncludeFolder( strFolderName.. strFolder.. "/"  )
    end
end

function Seth.Area:DownloadResources()
        if Seth.Area.CONFIG.FastDL then
                if !SERVER then return end
                resource.AddWorkshop( "1746544336" )
        end
end


Seth.Area:IncludeFolder( "seth_gps/" )
Seth.Area:DownloadResources()
