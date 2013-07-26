SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.HoldType			= "pistol"

SWEP.ShootSound			= Sound( "Weapon_Pistol.Single" )
SWEP.ReloadSound		= Sound( "Weapon_Pistol.Reload" )
SWEP.EmptySound			= Sound( "Weapon_Pistol.Empty" )

SWEP.Primary.Ammo		= "pistol"
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

	if SERVER then
		self.Owner:SetAmmo( 1, "pistol" )
	end

	return true
end

function SWEP:TakePrimaryAmmo( num )
	if SERVER then
		self.Owner:SetAmmo( num, "pistol" )
	end

	self:SetClip1( self:Clip1() - num )
end

function SWEP:Reload()
	if ( self:Clip1() >= self.Primary.ClipSize ) then return end
	if !self:DefaultReload( ACT_VM_RELOAD ) then return end

	if ( self:GetNextReload() <= CurTime() && self:DefaultReload( ACT_VM_RELOAD ) ) then
		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
		self:SetNextReload( self:SequenceDuration() )
		self.IdleAnimation = CurTime() + self:SequenceDuration()

		self.Owner:DoReloadEvent()
		self:SendWeaponAnim( ACT_VM_RELOAD )
		self:EmitSound( self.ReloadSound )
	end
end

function SWEP:CanPrimaryAttack()
	if ( self:GetNextReload() > CurTime() ) then return false end

	if ( self:Clip1() <= 0 ) then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:EmitSound( self.EmptySound )

		return false
	end

	return true
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextReload( self.Primary.Delay / 2 )
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local bullet = {}
	bullet.Num			= self.Primary.Shots
	bullet.Src			= self.Owner:GetShootPos()
	bullet.Dir			= self.Owner:GetAimVector()
	bullet.Spread		= Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Damage		= self.Primary.Damage
	bullet.AmmoType		= self.Primary.Ammo

	self:TakePrimaryAmmo( self.Primary.Shots )
	self.Owner:FireBullets( bullet )
	self.Owner:DoAttackEvent()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:EmitSound( self.ShootSound )
end


function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:SecondaryAttack()
end