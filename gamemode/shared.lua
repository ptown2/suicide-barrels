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

GM.Name		= "Suicide Barrels"
GM.Author	= "ogniK & ptown2"
GM.Email	= "xptown2x@gmail.com"
GM.Website	= "http://ptown2.0fees.net/"
GM.Revision	= 30


include( "sh_globals.lua" )
include( "sh_loading.lua" )
include( "sh_utils.lua" )
include( "sh_states.lua" )

include( "obj_weapon_extend_sh.lua" )

include( "classes/class_default.lua" )
include( "classes/class_human.lua" )
include( "classes/class_barrel.lua" )

if file.Exists( GM.FolderName.. "/gamemode/maps/" ..game.GetMap().. ".lua", "LUA" ) then
	include( "maps/" ..game.GetMap().. ".lua" )
end



function GM:PrecacheResources()
	util.PrecacheModel( "models/props_c17/oildrum001_explosive.mdl" )

	for name, mdl in pairs( player_manager.AllValidModels() ) do
		util.PrecacheModel( mdl )
	end
end

function GM:GetGameDescription()
	return self.Name
end

function GM:UpdateAnimation( pl, vel, seq )
	if ( pl:Team() == TEAM_OIL ) then
		pl:SetRenderAngles( Angle( 0, 0, 0 ) )
	end
end

function GM:PlayerFootstep( pl, vPos, iFoot, strSoundName, fVolume, pFilter )
	fVolume = fVolume * 2

	return pl:Team() == TEAM_OIL
end

function GM:CallStateFunction( state, stype, ... )
	local state = self.STATES[ state ]
	local metaFunc = state[ stype ]

	if ( state && metaFunc ) then
		metaFunc( self, ... )
	end
end