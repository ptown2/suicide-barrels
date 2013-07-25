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


function GM:AddResources()
	--resource.AddFile()
end

function GM:AddNetworkStrings()
	--util.AddNetworkString( "" )
end

function GM:PrecacheResources()
	--util.PrecacheModel()
	--util.PrecacheSound()

	util.PrecacheModel( "models/props_c17/oildrum001_explosive.mdl" )

	for name, mdl in pairs( player_manager.AllValidModels() ) do
		util.PrecacheModel( mdl )
	end
end

function GM:Initialize()
	self:AddResources()
	self:AddNetworkStrings()
	self:PrecacheResources()
	self:SetupSpawns()
	self:LoadModules()
end

function GM:Think()
	-- Do some round timer here.
end

function GM:CheckTeams()
	-- Do team checking here.
end

function GM:SetupSpawns()
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetSpawnPoint( TEAM_BARREL, { "info_player_start", "info_player_counterterrorist", "info_player_combine" } )
end

function GM:SetupHuman( pl )
	local desiredname = pl:GetInfo("cl_playermodel")

	if #desiredname == 0 then
		pl:SetModel( "models/player/alyx.mdl" )		--Just incase the player has NO model selected.
	else
		pl:SetModel( player_manager.TranslatePlayerModel( desiredname ) )
	end

	local pcol = Vector( pl:GetInfo( "cl_playercolor" ) ) 
	pcol.x = math.Clamp( pcol.x, 0, 2.5 )
	pcol.y = math.Clamp( pcol.y, 0, 2.5 )
	pcol.z = math.Clamp( pcol.z, 0, 2.5 )
	pl:SetPlayerColor( pcol )

	local wcol = Vector( pl:GetInfo( "cl_weaponcolor" ) )
	wcol.x = math.Clamp( wcol.x, 0, 2.5 )
	wcol.y = math.Clamp( wcol.y, 0, 2.5 )
	wcol.z = math.Clamp( wcol.z, 0, 2.5 )
	pl:SetWeaponColor( wcol )

	pl:SetWalkSpeed( 200 )
	pl:SetRunSpeed( 260 )
	pl:Give( "weapon_sb_pistol" )
end

function GM:SetupBarrel( pl )
	pl:SetModel( "models/props_c17/oildrum001_explosive.mdl" )

	pl:SetWalkSpeed( 150 )
	pl:SetRunSpeed( 250 )

	pl:SetMaxHealth( 1 )
	pl:SetHealth( pl:GetMaxHealth() )

	pl.CanExplode = CurTime() + 2
	pl.CanTaunt = CurTime() + 1
end

function GM:PlayerInitialSpawn( pl )
	--[[if ( pl:IsBot() ) then
		pl:SetTeam( TEAM_OIL )
		return
	end]]

	pl:SetTeam( TEAM_HUMAN )
end

function GM:PlayerSpawn( pl )
	pl:StripWeapons()
	pl:SetColor(color_white)

	if pl:Team() == TEAM_HUMAN then
		self:SetupHuman( pl )
	else
		self:SetupBarrel( pl )
	end
end

-- METATABLE THIS PLZ
function GM:PlayerExplode( pl, range )
	local explode = ents.Create( "env_explosion" )
	explode:SetPos( pl:GetPos() )
	explode:SetOwner( pl )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", range )
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 )
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	if !IsValid( pl ) || !IsValid( attacker ) then return end

	pl:AddDeaths( 1 )

	if ( pl ~= attacker ) then
		attacker:AddFrags( 1 )
	end

	if ( pl:Team() == TEAM_OIL ) && ( pl ~= attacker ) then
		self:PlayerExplode( pl, 96 )		-- METATABLE THIS PLZ
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
			-- idk, I was BORED. K?
			timer.Simple( 0.5, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
			timer.Simple( 1.0, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
			timer.Simple( 1.5, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Weapon_CombineGuard.Special1" ) end end )
			timer.Simple( 2.5, function() if IsValid( pl ) && pl:Alive() then self:PlayerExplode( pl, 128 ) end end )
			pl.CanExplode = CurTime() + 3
		elseif ( key == IN_ATTACK2 ) && ( pl.CanTaunt <= CurTime() ) then
			pl:EmitSound( table.Random( TAUNTS ), 90, math.random( 150, 175 ) )
			pl.CanTaunt = CurTime() + 1.5
		end
	end
end

function GM:CanPlayerSuicide( pl )
	return pl:Team() == TEAM_HUMAN
end

-- idk, never tested this
function GM:PlayerCanHearPlayersVoice( pl1, pl2 )
	if ( pl1:IsPlayer() && pl2:IsPlayer() ) then
		return ( pl1:Team() == pl2:Team() )
	end

	return true
end