SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.HoldType			= "pistol"

SWEP.ShootSound			= Sound( "Weapon_Pistol.Single" )
SWEP.ReloadSound		= Sound( "Weapon_Pistol.Reload" )
SWEP.EmptySound			= Sound( "Weapon_Pistol.Empty" )

SWEP.Primary.Damage		= 9999
SWEP.Primary.ClipSize	= 1
SWEP.Primary.Shots		= 1
SWEP.Primary.Spread		= 0.2
SWEP.Primary.Delay		= 0.35

-- Meta Functions (Soon to be actually meta)
function SWEP:GetNextReload()
	return self.m_NextReload || 0
end

function SWEP:SetNextReload( fTime )
	self.m_NextReload = CurTime() + fTime
end


function SWEP:Initialize()
	if !IsValid( self ) then return end	--???

	self:SetWeaponHoldType( self.HoldType )
	self:SetDeploySpeed( 1.1 )
end

function SWEP:Deploy()
	self:SetNextReload( 0 )
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:Reload()
	if !self:DefaultReload( ACT_VM_RELOAD ) then return end		-- Fixes the double reload bug.
	if ( self:Clip1() >= self.Primary.ClipSize ) then return end

	if ( self:GetNextReload() <= CurTime() && self:DefaultReload( ACT_VM_RELOAD ) ) then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload( self:SequenceDuration() )

		timer.Simple( self:SequenceDuration() * 0.85, function() self:SetClip1( 1 ) end )
		self:EmitSound( self.ReloadSound )
		self.Owner:DoReloadEvent()
		self:SendWeaponAnim( ACT_VM_RELOAD )
	end
end

function SWEP:CanPrimaryAttack()
	if ( self:Clip1() <= 0 ) then
		self:EmitSound( self.EmptySound )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local bullet = {}
	bullet.Num			= self.Primary.Shots
	bullet.Src			= self.Owner:GetShootPos()
	bullet.Dir			= self.Owner:GetAimVector()
	bullet.Spread		= Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Damage		= self.Primary.Damage
	bullet.AmmoType		= self.Primary.Ammo

	self:TakePrimaryAmmo( self.Primary.Shots )
	self:EmitSound( self.ShootSound )
	self.Owner:FireBullets( bullet )
	self.Owner:DoAttackEvent()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end


function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack()
end