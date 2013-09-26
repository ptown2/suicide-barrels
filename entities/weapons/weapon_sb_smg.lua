AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Submachine Gun"
	SWEP.Slot = 0
	SWEP.SlotPos = 1

	SWEP.ViewModelFOV = 70
end

SWEP.Base = "weapon_sb_base"

SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.UseHand			= true
SWEP.HoldType			= "smg"

SWEP.ReloadSound		= Sound( "Weapon_SMG1.Reload" )

SWEP.Primary.Sound		= Sound( "Weapon_AR2.NPC_Single" )
SWEP.Primary.Damage		= 100
SWEP.Primary.NumShots	= 1
SWEP.Primary.ClipSize	= 1
SWEP.Primary.Automatic	= true
SWEP.Primary.Delay		= 0.125
SWEP.Primary.Ammo		= "pistol"

SWEP.ConeMax			= 0.08
SWEP.ConeMin			= 0.015

SWEP.IronSightsAng		= Vector( 0.8, 0, 0 )
SWEP.IronSightsPos		= Vector( -6.41, -4, 0.85 )
