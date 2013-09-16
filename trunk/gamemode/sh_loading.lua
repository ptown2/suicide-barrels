module( "GLoad", package.seeall )

GamemodeName = GM.FolderName

function LoadDirectory( directory, addcsonly )
	local filename, foldername = file.Find( GamemodeName.. "/gamemode/" ..directory.. "/*.*", "LUA" )

	for _, filen in ipairs( filename ) do
		if ( string.GetExtensionFromFilename( filen ) == "lua" ) then
			if addcsonly then
				AddCSFile( directory.. "/" ..filen )
			else
				LoadFile( directory.. "/" ..filen )
			end
		end
	end

	for _, foldern in ipairs( foldername ) do
		LoadDirectory( directory.. "/" ..foldern )
	end
end

function LoadFile( filename )
	local filetype = string.sub( string.GetFileFromFilename( filename ), 1, 3 )
	local classtype = string.sub( string.GetFileFromFilename( filename ), 1, 6 )

	if ( string.lower( filetype ) == "sv_" ) || ( filename == "init.lua" ) then
		if SERVER then include( filename ) end
	elseif ( string.lower( filetype ) == "cl_" ) || ( filename == "cl_init.lua" ) then
		if SERVER then AddCSLuaFile( filename ) end
		if CLIENT then include( filename ) end
	elseif ( string.lower( filetype ) == "sh_" ) || ( filename == "shared.lua" ) then
		if SERVER then AddCSLuaFile( filename ) end
		include( filename )
	else
		if SERVER then AddCSLuaFile( filename ) end
		include( filename )		
	end
end

function AddCSFile( filename )
	local filetype = string.sub( string.GetFileFromFilename( filename ), 1, 3 )

	if ( string.lower( filetype ) == "cl_" ) || ( filename == "cl_init.lua" ) then
		if SERVER then AddCSLuaFile( filename ) end
	elseif ( string.lower( filetype ) == "sh_" ) || ( filename == "shared.lua" ) then
		if SERVER then AddCSLuaFile( filename ) end
	end
end 