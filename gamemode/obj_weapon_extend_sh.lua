local meta = FindMetaTable( "Weapon" )
if !meta then return end

function meta:GetNextReload()
	return self.m_NextReload || 0
end

function meta:SetNextReload( fTime )
	self.m_NextReload = CurTime() + fTime
end

function meta:CanPrimaryAttack()
	if ( GAMEMODE:GetState() ~= STATE_PLAYING ) then return false end

	if ( self:Clip1() <= 0 ) then
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:EmitSound( self.EmptySound )

		return false
	end

	return true
end