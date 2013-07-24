/*
	Suicide Barrels - GM13 Edition

	Redone/Recoded by: ptown2 (Robert Lind)
	Original Authors:
		*
		*
		*
*/

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

AddCSLuaFile("cl_init.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_loading.lua")

include( "shared.lua" )

function GM:ManageNetworks()
	--util.AddNetworkString( "" )
end

function GM:Initialize()
	self:PrecacheResources()
	self:ManageNetworks()
	self:LoadModules()
end

function GM:PlayerLoadout( pl )
	pl:Give( "weapon_pistol" )
end