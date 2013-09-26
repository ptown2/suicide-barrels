AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Last Human' Pistol"
	SWEP.Slot = 5
	SWEP.SlotPos = 0

	SWEP.ViewModelFOV = 70
end

SWEP.Base = "weapon_sb_base"

SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.UseHand			= true
SWEP.HoldType			= "pistol"

SWEP.ReloadSound		= Sound("Weapon_Pistol.Reload")

SWEP.Primary.Sound		= Sound( "Weapon_Pistol.NPC_Single" )
SWEP.Primary.Damage		= 100
SWEP.Primary.NumShots	= 1
SWEP.Primary.ClipSize	= 15
SWEP.Primary.Automatic	= true
SWEP.Primary.Delay		= 0.05
SWEP.Primary.Ammo		= "pistol"

SWEP.ConeMax			= 0.2
SWEP.ConeMin			= 0

SWEP.IronSightsPos = Vector( -5.85, -4.5, 3.1 )
SWEP.IronSightsAng = Vector( 0.15, -1, 1.5 )