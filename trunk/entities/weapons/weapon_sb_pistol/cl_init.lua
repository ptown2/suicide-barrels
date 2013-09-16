include( "shared.lua" )

SWEP.PrintName		= "Pistol"

SWEP.Slot			= 0
SWEP.SlotPos		= 1

SWEP.DrawAmmo		= true
SWEP.DrawCrosshair	= true

SWEP.ViewModelFOV	= 65
SWEP.ViewModelFlip	= false

SWEP.BobScale		= 1
SWEP.SwayScale		= 1

function SWEP:DrawHUD()
	local t = RealTime() * 2

	//draw.RoundedBox( 4, ScrW() - 168 - 32, ScrH() - 110, 144, 62, Color( 0, 0, 0, 255 ) )

	if ( self:Clip1() <= 0 ) then
		draw.TextRotated( "RELOAD", ScrW() - 128, ScrH() - 75, Color( 255, 0, 0, 220 + math.sin(CurTime() * 10) * 35 ) , "SB_TextBHuge", 10 * math.sin( t ) )
		//draw.DrawText( "RELOAD", "GModNotify", ScrW() / 2, ( ScrH() / 2 ) + 28, Color( 255, 0, 0, 220 + math.sin(CurTime() * 10) * 35 ), TEXT_ALIGN_CENTER )
	else
		draw.TextRotated( self:Clip1() .." / ".. self.Primary.ClipSize, ScrW() - 128, ScrH() - 75, Color( 0, 255, 0, 220 + math.sin(CurTime() * 10) * 35 ) , "SB_TextBHuge", 7 * math.sin( t ) )
	end
end