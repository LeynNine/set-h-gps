--[[
	name: sv_data.lua
]]--

local DATA = {}

-- STRING
local STR_FILE_PATH = "seth/gps/"

-- INT
local INT_DIST = 100
local INT_DELETE_DIST = 100

-- Create data files 
function DATA:CreateFiles()
	Seth.Area:Print("[ DATA ] ".. Seth.Area.LANGUAGE:Get( "CONSOLE:DataLoading"))

	if !file.IsDir(STR_FILE_PATH , "DATA") then
		file.CreateDir(STR_FILE_PATH)
	end
	if !file.Exists(STR_FILE_PATH.. "gps.txt", "DATA") then
		file.Write(STR_FILE_PATH.. "gps.txt", "[]")
	end

	Seth.Area:Print("[ DATA ] ".. Seth.Area.LANGUAGE:Get( "CONSOLE:DataLoad"))
end

-- Returns the content of a data file
function DATA:GetFileContent(strFile)
	local strPath = STR_FILE_PATH.. strFile

	if !file.Exists(strPath, "DATA") then return {} end
	return util.JSONToTable(file.Read(strPath, "DATA"))
end

-- Saves a position in data
function DATA:SavePoint( tblContent )
	file.Write(STR_FILE_PATH.. "gps.txt", util.TableToJSON(tblContent))
end

-- Adds a position in the data
function DATA:AddPoint(pPlayer, strName, strDesc, colPoint, vecPos)
	local tblPoint = self:GetFileContent("gps.txt")
	local bolAlreadyCreated = false

	if !tblPoint or !istable(tblPoint) then return end
	for strPointName, tblData in pairs(tblPoint or {}) do
		if strPointName == strName or tblData.Vector:DistToSqr(vecPos) < INT_DIST ^2 then
			bolAlreadyCreated = true
			break
		end
	end

	if bolAlreadyCreated then
		Seth.Area.NOTIFY:AddNotify(pPlayer, Seth.Area.LANGUAGE:Get( "NOTIFY:SimilarPoint" ), true, 5)
		return false
	end

	tblPoint[strName] = {Desc = strDesc, Color = colPoint, Vector = vecPos}
	self:SavePoint(tblPoint)

	Seth.Area.NOTIFY:AddNotify(pPlayer, "[ "..strName .. " ] - ".. Seth.Area.LANGUAGE:Get( "NOTIFY:PointAdded" ), true, 5)
	return true
end

-- Delete a position in the data
function DATA:RemovePoint(pPlayer, vecPos)
	local tblPoint = self:GetFileContent("gps.txt")
	local bolIsValid = false

	if !tblPoint or !istable(tblPoint) then return end
	for strName, tblData in pairs(tblPoint or {}) do
		if tblData.Vector:DistToSqr(vecPos) < INT_DELETE_DIST ^2 then
			tblPoint[strName] = nil
			bolIsValid = strName
			break
		else
			bolIsValid = false
		end
	end
	if !bolIsValid then return false end

	self:SavePoint(tblPoint)
	Seth.Area.NOTIFY:AddNotify(pPlayer, "[ "..bolIsValid .. " ] - ".. Seth.Area.LANGUAGE:Get("NOTIFY:PointRemoved") , true, 5)

	return true, bolIsValid
end

Seth.Area.DATA = DATA
