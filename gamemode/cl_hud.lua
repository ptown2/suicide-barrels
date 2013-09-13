W, H = ScrW(), ScrH()

function draw.TextRotated( text, x, y, color, font, ang )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	surface.SetFont( font )
	surface.SetTextColor( color )
	surface.SetTextPos( 0, 0 )
	local textWidth, textHeight = surface.GetTextSize( text )
	local rad = -math.rad( ang )
	local halvedPi = math.pi / 2
	x = x - ( math.sin( rad + halvedPi ) * textWidth / 2 + math.sin( rad ) * textHeight / 2 )
	y = y - ( math.cos( rad + halvedPi ) * textWidth / 2 + math.cos( rad ) * textHeight / 2 )
	local m = Matrix()
	m:SetAngles( Angle( 0, ang, 0 ) )
	m:SetTranslation( Vector( x, y, 0 ) )
	cam.PushModelMatrix( m )
		surface.DrawText( text )
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end

function GM:HUDPaint()
	if !IsValid( MySelf ) then return end

	player_manager.RunClass( MySelf, "HUDPaint" )

	self:CallStateFunction( self:GetState(), "DrawHUD" )
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