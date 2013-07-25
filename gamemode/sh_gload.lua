/* --------------------------------------------------------------------------
	Suicide Barrels GM13 Edition
	Copyright (C) 2013  Robert Lind (ptown2) and David Marcec (ogniK)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------- */

module( "GLoad", package.seeall )

GamemodeName = GM.FolderName

function LoadDirectory( directory )
	local filename, foldername = file.Find( GamemodeName.. "/gamemode/" ..directory.. "/*", "LUA" )

	for _, filen in ipairs( filename ) do
		LoadFile( directory.. "/" ..filen )
	end

	for _, foldern in ipairs( foldername ) do
		LoadDirectory( directory.. "/" ..foldern )
	end
end

function LoadFile( filename )
	local filetype = string.sub( string.GetFileFromFilename( filename ), 1, 3 )
	print(filename)
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