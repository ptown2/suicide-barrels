local meta = FindMetaTable( "Weapon" )
if !meta then return end

meta.GetNextPrimaryAttack	= meta.GetNextPrimaryFire
meta.GetNextSecondaryAttack = meta.GetNextSecondaryFire
meta.SetNextPrimaryAttack	= meta.SetNextPrimaryFire
meta.SetNextSecondaryAttack = meta.SetNextSecondaryFire

function meta:GetNextReload()
	return self.m_NextReload or 0
end

function meta:SetNextReload( fTime )
	self.m_NextReload = fTime
end

function meta:GetPrimaryAmmoCount()
	return self.Owner:GetAmmoCount(self.Primary.Ammo) + self:Clip1()
end

function meta:GetSecondaryAmmoCount()
	return self.Owner:GetAmmoCount(self.Secondary.Ammo) + self:Clip2()
end

function meta:HideViewAndWorldModel()
	self:HideViewModel()
	self:HideWorldModel()
end
meta.HideWorldAndViewModel = meta.HideViewAndWorldModel

if SERVER then
	function meta:HideWorldModel()
		self:DrawShadow(false)
	end

	function meta:HideViewModel()
	end
end


if not CLIENT then return end

function meta:DrawCrosshair()
	self:DrawCrosshairCross()
	self:DrawCrosshairDot()
end

local CrossHairScale = 1
local function DrawDot( x, y )
	surface.SetDrawColor( GAMEMODE.CrosshairColor )
	surface.DrawRect( x - 2, y - 2, 4, 4 )
	surface.SetDrawColor( 0, 0, 0, 220 )
	surface.DrawOutlinedRect( x - 2, y - 2, 4, 4 )
end

function meta:DrawCrosshairCross()
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	local ironsights = self.GetIronsights && self:GetIronsights()
	local owner = self.Owner
	local cone = self:GetCone()

	if ( cone <= 0 ) then return end

	cone = ScrH() / 76.8 * cone

	CrossHairScale = math.Approach( CrossHairScale, cone, FrameTime() * 5 + math.abs( CrossHairScale - cone ) * 0.02 )

	local scalebyheight = ( ScrH() / 768 ) * 0.2

	local midarea = 40 * CrossHairScale
	local length = scalebyheight * 24 + midarea / 4

	surface.SetDrawColor( GAMEMODE.CrosshairColor )
	surface.DrawRect( x - midarea - length, y - 2, length, 4 )
	surface.DrawRect( x + midarea, y - 2, length, 4 )
	surface.DrawRect( x - 2, y - midarea - length, 4, length )
	surface.DrawRect( x - 2, y + midarea, 4, length )

	surface.SetDrawColor( 0, 0, 0, 160)
	surface.DrawOutlinedRect( x - midarea - length, y - 2, length, 4 )
	surface.DrawOutlinedRect( x + midarea, y - 2, length, 4 )
	surface.DrawOutlinedRect( x - 2, y - midarea - length, 4, length )
	surface.DrawOutlinedRect( x - 2, y + midarea, 4, length )
end

function meta:DrawCrosshairDot()
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	surface.SetDrawColor(GAMEMODE.CrosshairColor2 )
	surface.DrawRect( x - 2, y - 2, 4, 4 )
	surface.SetDrawColor( 0, 0, 0, 220 )
	surface.DrawOutlinedRect( x - 2, y - 2, 4, 4 )
end

function meta:BaseDrawWeaponSelection( x, y, wide, tall, alpha )
	if killicon.Exists( self:GetClass() ) then
		killicon.Draw( x + wide * 0.5, y + tall * 0.5, self:GetClass(), 255 )

		draw.DrawText( self:GetPrintName(), "GModNotify", x + wide * 0.5, y + tall * 0.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		draw.DrawText( self:GetPrintName(), "GModNotify", x + wide * 0.5, y + tall * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

local function empty() end
local function NULLViewModelPosition( self, pos, ang )
	return pos + ang:Forward() * -256, ang
end

function meta:HideWorldModel()
	self:DrawShadow( false )
	self.DrawWorldModel = empty
	self.DrawWorldModelTranslucent = empty
end

function meta:HideViewModel()
	self.GetViewModelPosition = NULLViewModelPosition
end
