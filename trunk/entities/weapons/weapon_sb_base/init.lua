AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function SWEP:Think()
	if self.IdleAnimation && ( self.IdleAnimation <= CurTime() ) then
		self.IdleAnimation = nil
		self:SendWeaponAnim( ACT_VM_IDLE )
	end

	if self:GetIronsights() && !( self.Owner:KeyDown(IN_ATTACK2) ) then
		self:SetIronsights(false)
	end
end