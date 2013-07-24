module( "GLoad", package.seeall )

Gamemode = GM.FolderName 
function LoadDirectory(Directory)
	local File, Folder = file.Find( "gamemodes/"..Gamemode.."/gamemode/"..Directory.."/*", "GAME" )
	for k, v in pairs(File) do
		LoadFile(Directory.."/"..v)
	end
	for k,v in pairs(Folder) do
		LoadDirectory(Directory.."/"..v)
	end
end

function LoadFile(File)
	local FileType = string.sub(string.GetFileFromFilename(File), 1, 3)
	if(string.lower(FileType) == "sv_") then
		if SERVER then
			include(File)
		end
	elseif(string.lower(FileType) == "cl_") then
		AddCSLuaFile(File)
		if CLIENT then
			include(File)
		end
	elseif(string.lower(FileType) == "sh_") then
		if SERVER then
			AddCSLuaFile(File)
		end
		include(File)
	end
end 