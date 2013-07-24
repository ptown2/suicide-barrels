AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua")

include( "shared.lua" )

SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim( ACT_VM_IDLE )
	end
end
