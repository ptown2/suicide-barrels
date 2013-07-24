include( "shared.lua" )

function SWEP:DrawCrosshair()

end

function SWEP:DrawHUD()
	self:DrawCrosshair()

	local x, y, size = ScrW() / 2, ScrH() / 2, 12

	surface.SetDrawColor( Color( 0, 255, 0, 220 ) )
	surface.DrawLine( x, y, x + size, y )
	surface.DrawLine( x, y, x - size, y )
	surface.DrawLine( x, y, x, y + size )
	surface.DrawLine( x, y, x, y - size )
end