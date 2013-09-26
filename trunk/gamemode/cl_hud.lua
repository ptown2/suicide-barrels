W, H = ScrW(), ScrH()

local trace = { mask = MASK_SHOT, mins = Vector( -1, -1, -1 ), maxs = Vector( 1, 1, 1 ), filter = {} }

function GM:CreateFonts()
	surface.CreateFont( "SB_TextSmall", { font = "tahoma", size = 18, weight = 500, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextMed", { font = "tahoma", size = 26, weight = 500, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextHuge", { font = "tahoma", size = 34, weight = 500, antialias = false, outline = true } )

	surface.CreateFont( "SB_TextBSmall", { font = "tahoma", size = 18, weight = 1000, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextBMed", { font = "tahoma", size = 26, weight = 1000, antialias = false, outline = true } )
	surface.CreateFont( "SB_TextBHuge", { font = "tahoma", size = 34, weight = 1000, antialias = false, outline = true } )
end

function GM:HUDPaint()
	if !IsValid( LocalPlayer() ) then return end

	player_manager.RunClass( LocalPlayer(), "HUDPaint" )

	self:CallStateFunction( self:GetState(), "DrawHUD" )
	self:HUDDrawTargetID( LocalPlayer():Team() )
	self:DrawDeathNotice( 0.5, 0.025 )
end

function GM:HUDItemPickedUp()
	return false
end

function GM:HUDDrawTargetID( teamid )
	local start = EyePos()
	trace.start = start
	trace.endpos = start + EyeAngles():Forward() * 2048
	trace.filter[1] = LocalPlayer()
	trace.filter[2] = LocalPlayer():GetObserverTarget()

	local pl = util.TraceHull( trace ).Entity		--TraceLine or TraceHull...
	if pl:IsPlayer() && ( pl:Team() == teamid ) && pl:Alive() then
		surface.SetFont( "GModNotify" )

		local text = pl:Name()

		if pl:Team() == TEAM_HUMAN then
			text = text .." - ".. pl:Health() .."%"
		end

		local wid, hei = surface.GetTextSize( text )
		local tc = team.GetColor( pl:Team() )

		draw.RoundedBox( 4, ( ScrW() / 2 ) - ( wid * 0.5 ) - 6, ( ScrH() / 2 ) - 50, wid + 12, 32, color_black )
		draw.DrawText( text, "GModNotify", ( ScrW() / 2 ), ( ScrH() / 2 ) - 42, Color( tc.r, tc.g, tc.b, 255 ), TEXT_ALIGN_CENTER )
	end
end

function GM:HUDShouldDraw( hudn )
	if !IsValid( LocalPlayer() ) then return false end

	return ( hudn ~= "CHudHealth" ) && ( hudn ~= "CHudBattery" ) &&
	( hudn ~= "CHudAmmo" ) && ( hudn ~= "CHudSecondaryAmmo" ) &&
	( hudn ~= "CHudZoom" ) && ( hudn ~= "CHudDamageIndicator" )
	--&& ( hudn ~= "CHudWeaponSelection" )
end