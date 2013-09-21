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
GM.Website	= "http://ptown2.com/suicide-barrels"
GM.Revision	= 33


include( "sh_globals.lua" )
include( "sh_loading.lua" )
include( "sh_utils.lua" )
include( "sh_states.lua" )

include( "obj_entity_extend.lua" )
include( "obj_weapon_extend.lua" )

include( "classes/class_default.lua" )
include( "classes/class_human.lua" )
include( "classes/class_barrel.lua" )

if file.Exists( GM.FolderName.. "/gamemode/maps/" ..game.GetMap().. ".lua", "LUA" ) then
	include( "maps/" ..game.GetMap().. ".lua" )
end


local temppos = Vector()
local CachedEpicentreTimes = {}
local CachedEpicentres = {}

local function SortByDistance( a, b )
	return a:GetPos():Distance( temppos ) < b:GetPos():Distance( temppos )
end


function GM:PrecacheResources()
	for _, mdl in pairs( self.ValidBarrels ) do
		util.PrecacheModel( mdl )		
	end

	for _, mdl in pairs( player_manager.AllValidModels() ) do
		util.PrecacheModel( mdl )
	end
end

function GM:GetGameDescription()
	return self.Name
end

function GM:CallStateFunction( state, stype, ... )
	local state = self.STATES[ state ]
	local metaFunc = state[ stype ]

	if ( state && metaFunc ) then
		metaFunc( self, ... )
	end
end

function GM:GetClosestSpawnPoint( spawns, pos )
	local spawnpoints = spawns
	temppos = pos

	table.sort( spawnpoints, SortByDistance )

	return spawnpoints[ math.random( 1, #spawnpoints ) ]
end

function GM:IsOutCircularDistance( pl, ent )
	if ( !IsValid( pl ) ) then return false end

	return ( pl:GetPos():Distance( ent:NearestPoint( pl:GetPos() ) ) >= self.MaxSpawnDistance ) && ( pl:GetPos():Distance( ent:NearestPoint( pl:GetPos() ) ) <= self.MinSpawnDistance )
end

function GM:GetTeamEpicentre( teamid, nocache )
	if ( !nocache ) && ( CachedEpicentres[teamid] ) && ( CurTime() < CachedEpicentreTimes[teamid] ) then
		return CachedEpicentres[teamid]
	end

	local plys = team.GetPlayers( teamid )
	local vVec = Vector( 0, 0, 0 )
	for _, pl in pairs( plys ) do
		if ( pl:Alive() ) then
			vVec = vVec + pl:GetPos()
		end
	end

	local epicentre = vVec / #plys
	if ( !nocache ) then
		CachedEpicentreTimes[teamid] = CurTime() + 0.5
		CachedEpicentres[teamid] = epicentre
	end

	return epicentre
end

function GM:UpdateAnimation( pl, vel, seq )
	if ( !IsValid( pl ) ) then return end

	if ( pl:Team() == TEAM_OIL ) then
		pl:SetRenderAngles( Angle( 0, 0, 0 ) )
	end
end

function GM:PlayerFootstep( pl, vPos, iFoot, strSoundName, fVolume, pFilter )
	if ( !IsValid( pl ) ) then return false end

	fVolume = fVolume * 2

	return pl:Team() == TEAM_OIL
end