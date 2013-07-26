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


-- This is to handle the LocalPlayer in a way where you don't IsValid 1000 times.
MySelf = MySelf or NULL
hook.Add( "InitPostEntity", "GetLocal", function()
	MySelf = LocalPlayer()

	if IsValid( MySelf ) then
		hook.Remove( "GetLocal" )
	end
end )


function GM:CreateFonts()
	--surface.CreateFont( "HUDBig", {} )
end

function GM:Initialize()
	self:CreateFonts()
	self:PrecacheResources()
end

local trace = { mask = MASK_SHOT, mins = Vector( -1, -1, -1 ), maxs = Vector( 1, 1, 1 ), filter = {} }
function GM:HUDDrawTargetID( teamid )
	local start = EyePos()
	trace.start = start
	trace.endpos = start + EyeAngles():Forward() * 2048
	trace.filter[1] = MySelf
	trace.filter[2] = MySelf:GetObserverTarget()

	local plent = util.TraceLine(trace).Entity		--TraceLine or TraceHull...
	if plent:IsPlayer() && ( plent:Team() == teamid ) then
		surface.SetFont( "GModNotify" )

		local wid, hei = surface.GetTextSize( plent:Name() )
		local tc = team.GetColor( plent:Team() )
		draw.RoundedBox( 4, ( ScrW() / 2 ) - ( wid * 0.5 ) - 6, ( ScrH() / 2 ) - 50, wid + 12, 32, Color( 0, 0, 0, 255 ) )
		draw.DrawText( plent:Name(), "GModNotify", ( ScrW() / 2 ), ( ScrH() / 2 ) - 42, Color( tc.r, tc.g, tc.b, 255 ), TEXT_ALIGN_CENTER )
	end
end

function GM:HUDItemPickedUp()
	return false
end

function GM:HUDShouldDraw( hudn )
	if !IsValid( MySelf ) then return false end

	if ( MySelf:Team() == TEAM_HUMAN ) then
		return ( hudn ~= "CHudBattery" ) && --( hudn ~= "CHudAmmo" ) && 
		( hudn ~= "CHudSecondaryAmmo" ) && ( hudn ~= "CHudZoom" ) && 
		( hudn ~= "CHudWeaponSelection" )
	end

	return ( hudn ~= "CHudHealth" ) && ( hudn ~= "CHudBattery" ) &&
	( hudn ~= "CHudAmmo" ) && ( hudn ~= "CHudSecondaryAmmo" ) &&
	( hudn ~= "CHudZoom" ) && ( hudn ~= "CHudDamageIndicator" ) &&
	( hudn ~= "CHudWeaponSelection" )
end

function GM:HUDPaint()
	if !IsValid( MySelf ) then return end

	draw.DrawText( self:GetState(), "GModNotify", 32, 32, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	draw.DrawText( math.max( 0, self:GetTime() - CurTime() ), "GModNotify", 32, 64, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

	self:HUDDrawTargetID( MySelf:Team() )
	self:DrawDeathNotice( 0.5, 0.025 )
end