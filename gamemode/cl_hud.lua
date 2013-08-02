function GM:HUDPaint()
	if !IsValid( MySelf ) then return end

	player_manager.RunClass( MySelf, "CalcView" )

	self:HUDDrawTargetID( MySelf:Team() )
	self:DrawDeathNotice( 0.5, 0.025 )
end

function GM:HUDItemPickedUp()
	return false
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