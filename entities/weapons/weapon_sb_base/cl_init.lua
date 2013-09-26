include("shared.lua")

SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false
SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.BobScale				= 1
SWEP.SwayScale				= 1
SWEP.Slot					= 0

SWEP.IronsightsMultiplier	= 0.6

SWEP.HUD3DScale				= 0.01
SWEP.HUD3DBone				= "base"
SWEP.HUD3DAng				= Angle(180, 0, 0)


function SWEP:Deploy()
	return true
end

function SWEP:TranslateFOV(fov)
	return GAMEMODE.FOVLerp * fov
end

function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() then return GAMEMODE.FOVLerp end
end

local colBG = Color(16, 16, 16, 90)
local colRed = Color(220, 0, 0, 230)
local colYellow = Color(220, 220, 0, 230)
local colWhite = Color(220, 220, 220, 230)

function SWEP:Draw2DHUD()
	--local screenscale = BetterScreenScale()

	--[[local wid, hei = 180 * screenscale, 64 * screenscale
	local x, y = ScrW() - wid - screenscale * 128, ScrH() - hei - screenscale * 72]]

	local clip = self:Clip1()
	local maxclip = self.Primary.ClipSize
	local t = RealTime() * 2

	//draw.RoundedBox( 4, ScrW() - 168 - 32, ScrH() - 110, 144, 62, Color( 0, 0, 0, 255 ) )

	if ( clip <= 0 ) then
		draw.TextRotated( "RELOAD", ( ScrW() - 128 ) - ( 5 * math.cos( CurTime() * 5 ) ), ( ScrH() - 75 ) + ( 5 * math.sin( CurTime() * 5 ) ), Color( 255, 0, 0, 220 + math.sin( CurTime() * 10 ) * 35 ) , "SB_TextBHuge", 10 * math.sin( t ) )
	else
		draw.TextRotated( clip .." / ".. maxclip, ( ScrW() - 128 ) - ( 5 * math.cos( CurTime() * 5 ) ), ( ScrH() - 75 ) + ( 5 * math.sin( CurTime() * 5 ) ), Color( 0, 255, 0, 220 + math.sin( CurTime() * 10 ) * 35 ) , "SB_TextBHuge", 7 * math.sin( t ) )
	end
end

function SWEP:Think()
	if self:GetIronsights() && !( self.Owner:KeyDown(IN_ATTACK2) ) then
		self:SetIronsights( false )
	end
end

function SWEP:GetIronsightsDeltaMultiplier()
	local bIron = self:GetIronsights()
	local fIronTime = self.fIronTime || 0

	if not bIron and fIronTime < CurTime() - 0.25 then 
		return 0
	end

	local Mul = 1

	if fIronTime > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - fIronTime) * 4, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	return Mul
end

function SWEP:GetViewModelPosition(pos, ang)
	local bIron = self:GetIronsights()

	if bIron ~= self.bLastIron then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()

		if bIron then 
			self.SwayScale = 0.3
			self.BobScale = 0.1
		else 
			self.SwayScale = 2.0
			self.BobScale = 1.5
		end
	end

	local Mul = math.Clamp( ( CurTime() - ( self.fIronTime || 0 ) ) * 4, 0, 1 )
	if not bIron then Mul = 1 - Mul end

	if ( Mul > 0 ) then
		local Offset = self.IronSightsPos

		if self.IronSightsAng then
			ang = Angle(ang.p, ang.y, ang.r)
			ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
			ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
			ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
		end

		pos = pos + Offset.x * Mul * ang:Right() + Offset.y * Mul * ang:Forward() + Offset.z * Mul * ang:Up()
	end

	return pos, ang
end

function SWEP:DrawWeaponSelection( ... )
	return self:BaseDrawWeaponSelection( ... )
end

function SWEP:DrawHUD()
	self:DrawCrosshair()
	self:Draw2DHUD()
end