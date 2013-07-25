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

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_loading.lua" )
AddCSLuaFile( "sh_globals.lua" )

include( "shared.lua" )

include( "sv_setup.lua" )
include( "sv_states.lua" )
include( "sv_rounds.lua" )

include( "obj_player_extend_sv.lua" )


function GM:Initialize()
	self:AddResources()
	self:AddNetworkStrings()
	self:PrecacheResources()
	self:SetupSpawns()

	self.m_State		= 0
	self.m_StateTime	= 0
	self.m_TimeLeft		= 0
end

function GM:PlayerInitialSpawn( pl )
	if ( self:GetState() == STATE_PLAYING || self:GetState() == STATE_ENDING ) then
		pl:SetTeam( TEAM_OIL )
	end

	pl:SetTeam( TEAM_HUMAN )
end

function GM:PlayerDisconnected( pl )
	self:CheckTeams()
end

function GM:OnPlayerChangedTeam( pl )
	self:CheckTeams()
end

function GM:PlayerSpawn( pl )
	pl:StripWeapons()
	pl:SetColor( color_white )

	pl:SetCanWalk( true )
	pl:SetCanZoom( false )
	pl:SetNoCollideWithTeammates( true )

	if ( pl:Team() == TEAM_HUMAN ) && ( self:GetState() ~= STATE_PLAYING ) then
		self:SetupHuman( pl )
	else
		self:SetupBarrel( pl )
	end
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	if !IsValid( pl ) || !IsValid( attacker ) then return end

	pl:AddDeaths( 1 )

	if ( pl ~= attacker ) then
		attacker:AddFrags( 1 )
	end

	if ( pl:Team() == TEAM_OIL ) && ( pl ~= attacker ) then
		pl:SourceExplode( 96 )
	end

	if ( pl:Team() == TEAM_HUMAN ) then
		pl:CreateRagdoll()
		pl:SetTeam( TEAM_OIL )
	end

	self:CheckTeams()
end

function GM:PlayerShouldTakeDamage( pl, attacker )
	if !IsValid( pl ) || !IsValid( attacker ) then return false end

	if ( pl:IsPlayer() && attacker:IsPlayer() ) then
		return ( pl:Team() ~= attacker:Team() ) || ( pl == attacker )
	end

	return true
end

function GM:KeyPress( pl, key )
	if !pl:Alive() then return end

	if ( pl:Team() == TEAM_OIL ) then
		if ( key == IN_ATTACK ) && ( pl.CanExplode <= CurTime() ) then
			timer.Simple( 0.5, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
			timer.Simple( 1.0, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
			timer.Simple( 1.5, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Weapon_CombineGuard.Special1" ) end end )
			timer.Simple( 2.5, function() if IsValid( pl ) && pl:Alive() then pl:SourceExplode( 128 ) end end )
			pl.CanExplode = CurTime() + 3
		elseif ( key == IN_ATTACK2 ) && ( pl.CanTaunt <= CurTime() ) then
			pl:EmitSound( table.Random( self.TAUNTS ), 100, math.random( 150, 175 ) )
			pl.CanTaunt = CurTime() + 1.5
		end
	end
end

function GM:CanPlayerSuicide( pl )
	return ( pl:Team() == TEAM_HUMAN ) && ( self:GetState() == STATE_PLAYING )
end

function GM:PlayerCanHearPlayersVoice( pl1, pl2 )
	if ( pl1:IsPlayer() && pl2:IsPlayer() ) then
		return ( pl1:Team() == pl2:Team() )
	end

	return true
end