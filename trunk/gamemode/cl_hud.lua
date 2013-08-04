function GM:HUDPaint()
	if !IsValid( MySelf ) then return end

	if ( self:GetState() == STATE_NONE ) then
		draw.DrawText( "Requires 2 or more to start. Invite some!", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end

	if ( self:GetState() == STATE_WAITING ) then
		draw.DrawText( "Waiting for more players...", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.DrawText( math.ceil( math.max( 0, self:GetTime() - CurTime() ) ), "SB_TextBHuge", W / 2, H * 0.26, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end

	if ( self:GetState() == STATE_PREPARING ) then
		draw.DrawText( "Selecting a victim...", "SB_TextBMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	end

	if ( self:GetState() == STATE_PLAYING ) then
		draw.DrawText( "Time Remaining: " ..util.ToMinutesSeconds( math.ceil( math.max( 0, self:GetTime() - CurTime() ) ) ), "SB_TextBMed", 16, 44, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		draw.DrawText( "Humans: " ..#team.GetPlayers( TEAM_HUMAN ), "SB_TextBMed", W - 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
		draw.DrawText( "Barrels: " ..#team.GetPlayers( TEAM_OIL ), "SB_TextBMed", W - 16, 44, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	end

	if ( self:GetState() == STATE_ENDING ) then
		if ( self:GetTeamWinner() == TEAM_HUMAN ) then
			draw.DrawText( "The humans have survived.", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		elseif ( self:GetTeamWinner() == TEAM_OIL ) then
			draw.DrawText( "The barrels have taken over the human race.", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end
	end

	player_manager.RunClass( MySelf, "HUDPaint" )

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

	local plent = util.TraceHull(trace).Entity		--TraceLine or TraceHull...
	if plent:IsPlayer() && ( plent:Team() == teamid ) && plent:Alive() then
		surface.SetFont( "GModNotify" )

		local text = plent:Name()
		if plent:Team() == TEAM_HUMAN then
			text = text .." - ".. plent:Health() .."%"
		end

		local wid, hei = surface.GetTextSize( text )
		local tc = team.GetColor( plent:Team() )
		draw.RoundedBox( 4, ( ScrW() / 2 ) - ( wid * 0.5 ) - 6, ( ScrH() / 2 ) - 50, wid + 12, 32, Color( 0, 0, 0, 255 ) )
		draw.DrawText( text, "GModNotify", ( ScrW() / 2 ), ( ScrH() / 2 ) - 42, Color( tc.r, tc.g, tc.b, 255 ), TEXT_ALIGN_CENTER )
	end
end

function GM:HUDShouldDraw( hudn )
	if !IsValid( MySelf ) then return false end

	return ( hudn ~= "CHudHealth" ) && ( hudn ~= "CHudBattery" ) &&
	( hudn ~= "CHudAmmo" ) && ( hudn ~= "CHudSecondaryAmmo" ) &&
	( hudn ~= "CHudZoom" ) && ( hudn ~= "CHudDamageIndicator" ) &&
	( hudn ~= "CHudWeaponSelection" )
end