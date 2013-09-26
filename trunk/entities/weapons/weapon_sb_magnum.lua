AddCSLuaFile()

ShotsFired = 0
MaxRicochets = 5

if CLIENT then
	SWEP.PrintName = "Magnum"
	SWEP.Slot = 0
	SWEP.SlotPos = 2

	SWEP.ViewModelFOV = 70

	local killcolor = Color( 255, 40, 0, 255 )
	killicon.AddFont( "weapon_sb_pistol", "HL2MPTypeDeath", "-", killcolor )
	killicon.AddFont( "weapon_sb_smg", "HL2MPTypeDeath", "/", killcolor )
	killicon.AddFont( "weapon_sb_magnum", "HL2MPTypeDeath", ".", killcolor )
	killicon.AddFont( "weapon_sb_last", "HL2MPTypeDeath", "-", killcolor )
	killicon.AddFont( "env_explosion", "HL2MPTypeDeath", "7", killcolor )
end

SWEP.Base = "weapon_sb_base"

SWEP.ViewModel			= "models/weapons/c_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.UseHand			= true
SWEP.HoldType			= "revolver"

SWEP.Primary.Sound		= Sound( "Weapon_357.Single" )
SWEP.Primary.Damage		= 100
SWEP.Primary.NumShots	= 1
SWEP.Primary.ClipSize	= 2
SWEP.Primary.Automatic	= false
SWEP.Primary.Delay		= 0.65
SWEP.Primary.Ammo		= "pistol"

SWEP.ConeMax			= 0.08
SWEP.ConeMin			= 0.015

SWEP.IronSightsPos = Vector( -4.7, 1.7, 0.25 )
SWEP.IronSightsAng = Vector( 1, -0.2, 1 )

function DoRicochet( attacker, hitpos, hitnormal, normal, damage, bulletid )
	if !( attacker[ "magbulid" ..bulletid ] ) then
		attacker[ "magbulid" ..bulletid ] = 0
	end

	attacker[ "magbulid" ..bulletid ] = attacker[ "magbulid" ..bulletid ] + 1

	if ( attacker[ "magbulid" ..bulletid ] <= MaxRicochets ) then
		attacker:FireBullets({ Num = 1, Src = hitpos, Dir = 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, Spread = Vector(0, 0, 0), Tracer = 1, TracerName = "rico_trace", Force = damage, Damage = damage, Callback = attacker:GetActiveWeapon().BulletCallback })
	else
		attacker:FireBullets({ Num = 1, Src = hitpos, Dir = 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, Spread = Vector(0, 0, 0), Tracer = 1, TracerName = "rico_trace", Force = damage, Damage = damage, Callback = GenericBulletCallback })
	end
end

function SWEP:ShootBullets( dmg, numbul, cone )
	local owner = self.Owner
	self:SendWeaponAnimation()

	ShotsFired = ShotsFired + 1

	owner[ "magbulid" ..ShotsFired ] = 0
	owner:DoAttackEvent()
	owner:FireBullets({ Num = numbul, Src = owner:GetShootPos(), Dir = owner:GetAimVector(), Spread = Vector(cone, cone, 0), Tracer = 1, TracerName = self.TracerName, Force = dmg * 0.1, Damage = dmg, Callback = self.BulletCallback })
end

function SWEP.BulletCallback( attacker, tr, dmginfo )
	if SERVER && ( tr.HitWorld || tr.Entity ) && !tr.HitSky then
		timer.Simple( 0.1, function() DoRicochet( attacker, tr.HitPos, tr.HitNormal, tr.Normal, 9999, ShotsFired ) end )
	end
end
