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

	* Finish the Patriotic Class (get some fireworks entity).
	* Redo the SWEPs and make a base for it.
	* Recode some few parts and seperate them as it should be.
]]

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_draw.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_network.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_utils.lua" )
AddCSLuaFile( "sh_loading.lua" )
AddCSLuaFile( "sh_globals.lua" )
AddCSLuaFile( "sh_states.lua" )

AddCSLuaFile( "obj_entity_extend.lua" )
AddCSLuaFile( "obj_weapon_extend.lua" )

AddCSLuaFile( "vgui/dmodelselect.lua" )

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
	self:SetRounds( ROUND_LIMIT )
end

function GM:InitPostEntity()
	self:RandomizeBarrels()
	self:SetupSpawns()

	if self.MapHandling[ game.GetMap() ] then
		self.MinSpawnDistance	= self.MapHandling[ game.GetMap() ].Min || 512
		self.MaxSpawnDistance	= self.MapHandling[ game.GetMap() ].Max || 1024

		self.LeechesEnabled		= self.MapHandling[ game.GetMap() ].Leeches || false
	end
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
	elseif ( self:GetState() == STATE_PLAYING ) || ( self:GetState() == STATE_ENDING ) || ( self:GetState() == STATE_MAPCHANGE ) then
		pl:SetTeam( TEAM_OIL )
	end

	self:BroadcastData( pl )
	self:CheckTeams()
end

function GM:PlayerDisconnected( pl )
	self:CheckTeams( pl )
end

function GM:OnPlayerChangedTeam( pl )
	self:CheckTeams()
end

function GM:ShowSpare2( pl )
	pl:SendLua( "MakepPlayerModel()" )
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

function GM:PlayerSelectSpawn( pl )
	local ent, tab, potential = nil, {}, {}

	if ( pl:Team() == TEAM_HUMAN ) then
		local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )

		return ent
	else
		for _, spawn in pairs( team.GetSpawnPoints( pl:Team() ) ) do
			if IsValid( spawn ) && spawn:IsInWorld() then
				local blocked = false
				local spawnpos = spawn:GetPos()

				for _, entss in pairs( ents.FindInBox( spawnpos + Vector( -16, -16, 0 ), spawnpos + Vector( 16, 16, 72 ) ) ) do
					for _, pls in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
						if ( entss:IsPlayer() ) || ( self:IsOutCircularDistance( pls, entss ) ) && ( ent:IsValidBarrel() ) then
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

		if ( #team.GetPlayers( TEAM_HUMAN ) >= 1 ) then
			ent = self:GetClosestSpawnPoint( potential, self:GetTeamEpicentre( TEAM_HUMAN ) )
		else
			ent = table.Random( potential )
		end

		if ( !IsValid( ent ) ) then
			ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
		end

		pl:SetModel( ent:GetModel() )
		pl:SetSkin( ent:GetSkin() )
		pl.SpawnEnt = ent

		return ent
	end
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	if !IsValid( pl ) then return end

	if ( !pl:IsValidBarrel() ) then
		pl:CreateRagdoll()
	end

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

function GM:BroadcastData( pl )
	net.Start( "sb_syncdata" )
		net.WriteInt( self:GetState(), 4 )
		net.WriteInt( self:GetTime(), 16 )
		net.WriteInt( self:GetRoundsLeft(), 8 )
		net.WriteInt( self:GetTeamWinner(), 4 )
	net.Send( pl )
end

function GM:IsSpawnpointSuitable() return true end