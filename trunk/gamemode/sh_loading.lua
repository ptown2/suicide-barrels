module( "GLoad", package.seeall )

GamemodeName = GM.FolderName

function LoadDirectory( directory )
	local filename, foldername = file.Find( GamemodeName.. "/gamemode/" ..directory.. "/*", "LUA" )

	for _, filen in ipairs( filename ) do
		if ( string.GetExtensionFromFilename( filen ) == ".lua" ) then
			LoadFile( directory.. "/" ..filen )
		end
	end

	for _, foldern in ipairs( foldername ) do
		LoadDirectory( directory.. "/" ..foldern )
	end
end

function LoadFile( filename )
	local filetype = string.sub( string.GetFileFromFilename( filename ), 1, 3 )

	if ( string.lower( filetype ) == "sv_" ) || ( filename == "init.lua" ) then
		if SERVER then include( filename ) end
	elseif ( string.lower( filetype ) == "cl_" ) || ( filename == "cl_init.lua" ) then
		if SERVER then AddCSLuaFile( filename ) end
		if CLIENT then include( filename ) end
	elseif ( string.lower( filetype ) == "sh_" ) || ( filename == "shared.lua" ) then
		if SERVER then AddCSLuaFile( filename ) end
		include( filename )
	end
end 