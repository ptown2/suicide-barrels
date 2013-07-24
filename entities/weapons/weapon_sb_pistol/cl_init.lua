include( "shared.lua" )

SWEP.PrintName		= "Pistol"

SWEP.Slot			= 0
SWEP.SlotPos		= 1

SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false

SWEP.ViewModelFOV	= 65
SWEP.ViewModelFlip	= false

SWEP.BobScale		= 1
SWEP.SwayScale		= 1

function SWEP:DrawCrosshair()
	local x, y, size = ScrW() / 2, ScrH() / 2, 12

	surface.SetDrawColor( Color( 0, 255, 0, 220 ) )
	surface.DrawLine( x, y, x + size, y )
	surface.DrawLine( x, y, x - size, y )
	surface.DrawLine( x, y, x, y + size )
	surface.DrawLine( x, y, x, y - size )
end

function SWEP:DrawHUD()
	self:DrawCrosshair()

	draw.DrawText("CLIP", "GModNotify", ScrW() - 48, ScrH() - 48, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
end