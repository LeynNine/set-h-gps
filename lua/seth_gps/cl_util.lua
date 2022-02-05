--[[
	name: cl_util.lua
]]--

local UTIL = {}

-- Many fonts
surface.CreateFont( "Seth:Area:Purista:14", { font = "Purista", size = 14 } )
surface.CreateFont( "Seth:Area:Purista:16", { font = "Purista", size = 16 } )
surface.CreateFont( "Seth:Area:Purista:16:Bold", { font = "Purista", size = 16, weight = 550 } )
surface.CreateFont( "Seth:Area:Purista:16:Italic", { font = "Purista", size = 16, italic = true } )
surface.CreateFont( "Seth:Area:Purista:18", { font = "Purista", size = 18 } )
surface.CreateFont( "Seth:Area:Purista:18:Italic", { font = "Purista", size = 18, italic = true } )
surface.CreateFont( "Seth:Area:Purista:18:Bold", { font = "Purista", size = 18, weight = 550 } )
surface.CreateFont( "Seth:Area:Purista:20:Italic", { font = "Purista", size = 20, italic = true } )
surface.CreateFont( "Seth:Area:Purista:22", { font = "Purista", size = 22 } )
surface.CreateFont( "Seth:Area:Purista:22:Bold", { font = "Purista", size = 22, weight = 550 } )
surface.CreateFont( "Seth:Area:Purista:27", { font = "Purista", size = 27 } )
surface.CreateFont( "Seth:Area:Purista:35:Italic", { font = "Purista", size = 35, italic = true } )
surface.CreateFont( "Seth:Area:Purista:45:Bold", { font = "Purista", size = 45, weight = 550 } )

-- Split a string to return a paragraph
function UTIL:SplitString( strText, intLimit )
        local intSplit = 0
        local intCountLine = 1

    for intChar = 1, string.len( strText ) do
                local strChar = string.GetChar( strText, intChar )
                if strChar == " " and intSplit >= intLimit then
                    strText = string.SetChar( strText, intChar, "\n" )
                    intSplit = 0
                    intCountLine = intCountLine +1
                end

                if strChar == "\n" then
                    intSplit = 0
                    intCountLine = intCountLine +1
                end
        intSplit = intSplit +1
    end
    return strText, intCountLine
end

-- Draw material
function UTIL:DrawMaterial(colTexture, matTexture, intX, intH, intWide, intTall)
    surface.SetDrawColor(colTexture)
	surface.SetMaterial(matTexture)
	surface.DrawTexturedRect(intX, intH, intWide, intTall)
end

Seth.Area.UTIL = UTIL
