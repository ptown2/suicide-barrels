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

--[[
TODO LIST:

	* Finish the Barrel-O-Vision
	* Recode some few parts and seperate them as it should be.
]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_utils.lua" )
AddCSLuaFile( "sh_loading.lua" )
AddCSLuaFile( "sh_globals.lua" )
AddCSLuaFile( "sh_states.lua" )

AddCSLuaFile( "obj_entity_extend.lua" )
AddCSLuaFile( "obj_weapon_extend.lua" )

--GM:AddCSFolder( "maps" )
--GM:AddCSFolder( "classes" )

AddCSLuaFile( "maps/sb_maze.lua" )
AddCSLuaFile( "maps/sb_cookies_barrelmania.lua" )

AddCSLuaFile( "classes/class_default.lua" )
AddCSLuaFile( "classes/taunt_camera.lua" )
AddCSLuaFile( "classes/class_human.lua" )
AddCSLuaFile( "classes/class_barrel.lua" )

include( "shared.lua" )

include( "sv_setup.lua" )
include( "sv_rounds.lua" )

include( "obj_player_extend_sv.lua" )


function GM:Initialize()
	self:AddResources()
	self:AddNetworkStrings()
	self:PrecacheResources()

	self:SetState( STATE_NONE )
end

function GM:InitPostEntity()
	self:RandomizeBarrels()
	self:SetupSpawns()
end

function GM:Think()
	self:CallStateFunction( self:GetState(), "Think" )
end

function GM:OnReloaded()
	self:SetupSpawns()
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

	player_manager.RunClass( pl, "OnSpawn" )
	player_manager.RunClass( pl, "OnLoadout" )
end

local playermins = Vector( -17, -17, 0 )
local playermaxs = Vector( 17, 17, 4 )

function GM:PlayerSelectSpawn( pl )
	local tab, potential = {}, {}

	if ( pl:Team() == TEAM_HUMAN ) then
		local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )

		return ent
	else
		if ( !tab ) || ( #tab == 0 ) then tab = team.GetValidSpawnPoint( pl:Team() ) or {} end

		for _, spawn in pairs( tab ) do
			if IsValid( spawn ) && spawn:IsInWorld() then
				local blocked = false
				local spawnpos = spawn:GetPos()

				for _, ent in pairs( ents.FindInBox( spawnpos + playermins, spawnpos + playermaxs ) ) do
					for _, pls in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
						if ( ent:IsPlayer() && !spawninplayer ) || ( pls:GetPos():Distance( ent:NearestPoint( pls:GetPos() ) ) <= self.SpawnDistance ) then
							blocked = true
							break
						end
					end
				end

				if !blocked then
					potential[#potential + 1] = spawn
				end
			end
		end

		local ent = self:GetClosestSpawnPoint( potential, self:GetTeamEpicentre( TEAM_HUMAN ) )
		if ( !IsValid( ent ) ) then ent = self:PlayerSelectTeamSpawn( pl:Team(), pl ) end

		pl:SetModel( ent:GetModel() )
		pl:SetSkin( ent:GetSkin() )
		pl.SpawnEnt = ent

		return ent
	end
end

function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )
	local Pos = spawnpointent:GetPos()
	local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 64 ) )

	if ( pl:Team() == TEAM_SPECTATOR || pl:Team() == TEAM_UNASSIGNED ) then return true end

	local Blockers = 0
	for k, v in pairs( Ents ) do
		if ( IsValid( v ) && v:GetClass() == "player" && v:Alive() ) then
			Blockers = Blockers + 1
		end
	end

	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end

	return true
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	if !IsValid( pl ) then return end

	pl:AddDeaths( 1 )

	if IsValid( attacker ) && attacker:IsPlayer() && ( pl ~= attacker ) then
		attacker:AddFrags( 1 )
	end

	player_manager.RunClass( pl, "OnPlayerDeath", attacker )

	self:CheckTeams()
end

function GM:PlayerTick( pl )
	if !pl:Alive() then return end
	if ( self:GetState() ~= STATE_PLAYING ) then return end

	player_manager.RunClass( pl, "OnThink" )
end

function GM:KeyPress( pl, key )
	if !pl:Alive() then return end
	if ( self:GetState() ~= STATE_PLAYING ) then return end

	player_manager.RunClass( pl, "OnKeyPress", key )
end

function GM:KeyRelease( pl, key )
	if !pl:Alive() then return end
	if ( self:GetState() ~= STATE_PLAYING ) then return end

	player_manager.RunClass( pl, "OnKeyRelease", key )
end

function GM:PlayerNoClip( pl )
	return pl:IsAdmin()
end

function GM:CanPlayerSuicide( pl )
	return player_manager.RunClass( pl, "CanSuicide" )
end

function GM:PlayerShouldTakeDamage( pl, attacker )
	if ( self:GetState() ~= STATE_PLAYING ) then return false end

	if ( IsValid( pl ) && IsValid( attacker ) ) && ( pl:IsPlayer() && attacker:IsPlayer() ) then
		return ( pl:Team() ~= attacker:Team() ) || ( pl == attacker )
	end

	return true
end

function GM:PlayerCanHearPlayersVoice( pl1, pl2 )
	if ( pl1:IsPlayer() && pl2:IsPlayer() ) && ( self:GetState() ~= STATE_ENDING ) then
		return ( pl1:Team() == pl2:Team() )
	end

	return true
end

function GM:GetFallDamage( pl, speed )
	if ( pl:Team() == TEAM_OIL ) then return 0 end

	speed = speed - 225

	return ( speed / 25 ) * 3
end

//function GM:SetupPlayerVisibility( pl )
//	AddOriginToPVS( pl:GetPos() )
//end

function GM:BroadcastMusic( str, vol )
	net.Start( "sb_broadmusic" )
		net.WriteString( str )
		net.WriteInt( vol, 32 )
	net.Broadcast()
end