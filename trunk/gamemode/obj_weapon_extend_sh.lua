local meta = FindMetaTable( "Weapon" )
if !meta then return end

function meta:GetNextReload()
	return self.m_NextReload || 0
end

function meta:SetNextReload( fTime )
	self.m_NextReload = CurTime() + fTime
end
