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

include( "shared.lua" )

include( "vgui/dmodelselect.lua" )

include( "cl_draw.lua" )
include( "cl_hud.lua" )
include( "cl_network.lua" )


local ViewHullMins = Vector( -8, -8, -8 )
local ViewHullMaxs = Vector( 8, 8, 8 )


function GM:Initialize()
	self:CreateFonts()
	self:PrecacheResources()
end

function GM:ShouldDrawLocalPlayer()
	if ( !IsValid( LocalPlayer() ) ) then return false end

	return player_manager.RunClass( LocalPlayer(), "ShouldDrawLocalPlayer" )
end

function GM:CalcView( pl, origin, angles, fov, znear, zfar )
	local plview = player_manager.RunClass( pl, "CalcView", origin, angles, fov )

	return self.BaseClass.CalcView( self, pl, plview.origin, plview.angles, plview.fov, znear, zfar )
end

function GM:PreDrawHalos()
	if ( !IsValid( LocalPlayer() ) ) then return end
	if ( LocalPlayer():Team() ~= TEAM_OIL ) then return end

	effects.halo.Add( team.GetPlayers( TEAM_HUMAN ), Color( 0, 0, 255 ), 0, 0, 2, true, true )
end

function GM:PostDrawViewModel( vm, pl, weapon )
	if ( weapon.UseHands || weapon:IsScripted() ) then
		local hands = pl:GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
	end
end

function GM:SetThirdPerson( pl, origin, angles )
	if ( !origin || !angles ) then return end	--I have no idea why its supposed to error like that...

	local allplayers = player.GetAll()
	local tr = util.TraceHull( { start = origin, endpos = origin + angles:Forward() * -94 + angles:Up() * -12, mask = MASK_SHOT, filter = allplayers, mins = ViewHullMins, maxs = ViewHullMaxs } )

	return tr.HitPos + tr.HitNormal * 2
end

function GM:RunMusic( mid, loop )
	local mstr, mvol, mloop = GAMEMODE:HandleMusic( mid )

	RunConsoleCommand( "stopsound" )

	-- Check if the previous looping music exists.
	if ( self.LoopID && timer.Exists( "music" ..self.LoopID ) ) then
		timer.Destroy( "music" ..self.LoopID )
	end

	-- Check if the state had some looping music.
	if timer.Exists( "music" ..mid ) then
		timer.Destroy( "music" ..mid )
	end

	-- Loop or not to loop!
	if ( mloop ) then
		self.LoopID = mid

		timer.Simple( 0.1, function() if IsValid( LocalPlayer() ) then LocalPlayer():EmitSound( mstr, mvol ) end end )
		timer.Create( "music" ..self.LoopID, math.ceil( SoundDuration( mstr ) * 2.2401 ), 0, function() if IsValid( LocalPlayer() ) then LocalPlayer():EmitSound( mstr, mvol ) end end )
	else
		timer.Simple( 0.1, function() if IsValid( LocalPlayer() ) then LocalPlayer():EmitSound( mstr, mvol ) end end )
	end
end

function GM:HandleMusic( mid )
	local str, vol, loop = "", 0, false

	if self.MusicID[mid] then
		local MID = self.MusicID[mid]

		if ( STATE_ENDING ~= mid ) then

			-- Handle any other kind of music
			if istable( MID[1] ) then
				local music = table.Random( MID )
				str, vol, loop = music[1], music[2], music[3]
			else
				str, vol, loop = MID[1], MID[2], MID[3]
			end

		else

			-- Handle team winning music
			local winner = self:GetTeamWinner()
			if istable( MID[winner][1] ) then
				local music = table.Random( MID[winner] )
				str, vol, loop = music[1], music[2], music[3]
			else
				str, vol, loop = MID[winner][1], MID[winner][2], MID[winner][3]
			end

		end
	end

	return str, vol, loop
end