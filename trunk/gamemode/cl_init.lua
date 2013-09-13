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
include( "cl_hud.lua" )


-- This is to handle the LocalPlayer in a way where you don't get it as a nil value.
MySelf = MySelf or NULL
hook.Add( "InitPostEntity", "GetLocal", function()
	MySelf = LocalPlayer()

	if IsValid( MySelf ) then
		hook.Remove( "GetLocal" )
	end
end )

function GM:CreateFonts()
	surface.CreateFont( "SB_TextSmall", { font = "tahoma", size = 16, weight = 500, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextMed", { font = "tahoma", size = 24, weight = 500, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextHuge", { font = "tahoma", size = 32, weight = 500, antialias = false, outline = true } )

	surface.CreateFont( "SB_TextBSmall", { font = "tahoma", size = 16, weight = 1000, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextBMed", { font = "tahoma", size = 24, weight = 1000, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextBHuge", { font = "tahoma", size = 36, weight = 1000, antialias = false, outline = true } )
end

function GM:Initialize()
	self:CreateFonts()
	self:PrecacheResources()
end

function GM:ShouldDrawLocalPlayer()
	if ( !IsValid( MySelf ) ) then return false end

	return player_manager.RunClass( MySelf, "ShouldDrawLocalPlayer" )
end

function GM:CalcView( pl, origin, angles, fov, znear, zfar )
	local plview = player_manager.RunClass( pl, "CalcView", origin, angles, fov )

	return self.BaseClass.CalcView( self, pl, plview.origin, plview.angles, plview.fov, znear, zfar )
end

function GM:PostDrawViewModel( vm, pl, weapon )
	if ( weapon.UseHands || weapon:IsScripted() ) then
		local hands = pl:GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
	end
end

local ViewHullMins = Vector( -8, -8, -8 )
local ViewHullMaxs = Vector( 8, 8, 8 )
function GM:SetThirdPerson( pl, origin, angles )
	if ( !origin || !angles ) then return end	--I have no idea why its supposed to error like that...

	local allplayers = player.GetAll()
	local tr = util.TraceHull( { start = origin, endpos = origin + angles:Forward() * -94 + angles:Up() * -12, mask = MASK_SHOT, filter = allplayers, mins = ViewHullMins, maxs = ViewHullMaxs } )

	return tr.HitPos + tr.HitNormal * 2
end

net.Receive( "sb_broadmusic", function( len )
	local str = net.ReadString()
	local vol = net.ReadInt( 32 )

	RunConsoleCommand( "stopsound" )
	timer.Simple( 0.1, function() LocalPlayer():EmitSound( str, vol ) end )
end )

function GM:PreDrawHalos()
	if !IsValid( MySelf ) then return end
	if ( MySelf:Team() ~= TEAM_OIL ) then return end

	effects.halo.Add( team.GetPlayers( TEAM_HUMAN ), Color( 0, 0, 255 ), 0, 0, 2, true, true )
end