include( "shared.lua" )

SWEP.PrintName		= "Pistol"

SWEP.Slot			= 0
SWEP.SlotPos		= 1

SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true

SWEP.ViewModelFOV	= 65
SWEP.ViewModelFlip	= false

SWEP.BobScale		= 1
SWEP.SwayScale		= 1

function SWEP:DrawHUD()
	if self:Clip1() <= 0 then
		draw.RoundedBox( 4, ScrW() / 2 - 40, ScrH() / 2 + 20, 80, 32, Color( 0, 0, 0, 255 ) )
		draw.DrawText( "RELOAD", "GModNotify", ScrW() / 2, ( ScrH() / 2 ) + 28, Color( 255, 0, 0, 220 + math.sin(CurTime() * 6) * 35 ), TEXT_ALIGN_CENTER )
	end
end