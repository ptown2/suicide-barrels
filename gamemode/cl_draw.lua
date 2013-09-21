module( "draw", package.seeall )

function TextRotated( text, x, y, color, font, ang )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	surface.SetFont( font )
	surface.SetTextColor( color )
	surface.SetTextPos( 0, 0 )

	local textWidth, textHeight = surface.GetTextSize( text )
	local rad = -math.rad( ang )
	local halvedPi = math.pi / 2
	local m = Matrix()

	x = x - ( math.sin( rad + halvedPi ) * textWidth / 2 + math.sin( rad ) * textHeight / 2 )
	y = y - ( math.cos( rad + halvedPi ) * textWidth / 2 + math.cos( rad ) * textHeight / 2 )

	m:SetAngles( Angle( 0, ang, 0 ) )
	m:SetTranslation( Vector( x, y, 0 ) )

	cam.PushModelMatrix( m )
		surface.DrawText( text )
	cam.PopModelMatrix()

	render.PopFilterMag()
	render.PopFilterMin()
end