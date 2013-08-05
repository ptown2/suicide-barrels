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

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_utils.lua" )
AddCSLuaFile( "sh_loading.lua" )
AddCSLuaFile( "sh_globals.lua" )

AddCSLuaFile( "obj_weapon_extend_sh.lua" )

AddCSLuaFile( "classes/class_default.lua" )
AddCSLuaFile( "classes/taunt_camera.lua" )
AddCSLuaFile( "classes/class_human.lua" )
AddCSLuaFile( "classes/class_barrel.lua" )

include( "shared.lua" )

include( "sv_setup.lua" )
include( "sv_states.lua" )
include( "sv_rounds.lua" )

include( "obj_player_extend_sv.lua" )

GM.RoundsLeft = ROUND_LIMIT

function GM:Initialize()
	self:AddResources()
	self:AddNetworkStrings()
	self:PrecacheResources()
	self:SetupSpawns()

	self:SetState( STATE_NONE )
end

function GM:Think()
	self:CallStateFunction( self:GetState(), "Think" )
end

function GM:PlayerInitialSpawn( pl )
	pl:SetTeam( TEAM_HUMAN )

	if ( self:GetState() == STATE_NONE ) && ( #player.GetAll() > 1 ) then
		self:SetState( STATE_WAITING )
	elseif ( self:GetState() == STATE_PLAYING || self:GetState() == STATE_ENDING ) then
		pl:SetTeam( TEAM_OIL )
	end

	self:CheckTeams()
end

function GM:PlayerDisconnected( pl )
	self:CheckTeams( pl )
end

function GM:OnPlayerChangedTeam( pl )
	self:CheckTeams()
end

function GM:PlayerSpawn( pl )
	pl:StripWeapons()
	pl:StripAmmo()
	pl:SetNoCollideWithTeammates( true )
	pl:SetCanZoom( false )

	if ( pl:Team() == TEAM_HUMAN ) then
		player_manager.SetPlayerClass( pl, "class_human" )
	else
		player_manager.SetPlayerClass( pl, "class_barrel" )
	end

	player_manager.RunClass( pl, "OnSpawn", pl )
	player_manager.RunClass( pl, "OnLoadout", pl )
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	if !IsValid( pl ) || !IsValid( attacker ) then return end

	pl:AddDeaths( 1 )

	if ( pl ~= attacker ) then
		attacker:AddFrags( 1 )
	end

	player_manager.RunClass( pl, "OnPlayerDeath", pl, attacker )

	self:CheckTeams()
end

function GM:KeyPress( pl, key )
	if !pl:Alive() then return end
	if ( self:GetState() ~= STATE_PLAYING ) then return end

	player_manager.RunClass( pl, "OnKeyPress", pl, key )
end

function GM:CanPlayerSuicide( pl )
	return player_manager.RunClass( pl, "CanSuicide", pl )
end

function GM:PlayerShouldTakeDamage( pl, attacker )
	if ( self:GetState() ~= STATE_PLAYING ) then return false end
	if !IsValid( pl ) || !IsValid( attacker ) then return false end

	if ( pl:IsPlayer() && attacker:IsPlayer() ) then
		return ( pl:Team() ~= attacker:Team() ) || ( pl == attacker )
	end

	return true
end

function GM:PlayerCanHearPlayersVoice( pl1, pl2 )
	if ( pl1:IsPlayer() && pl2:IsPlayer() ) then
		return ( pl1:Team() == pl2:Team() )
	end

	return true
end

function GM:BroadcastMusic( str, vol )
	BroadcastLua( "RunConsoleCommand( \"stopsound\" )" )

	if ( vol && tonumber( vol ) ) then
		timer.Simple( 0.2, function() BroadcastLua( "LocalPlayer():EmitSound( \"" ..str.. "\", " ..vol.. " )" ) end )
		return
	end

	timer.Simple( 0.2, function() BroadcastLua( "LocalPlayer():EmitSound( \"" ..str.. "\" )" ) end )
end