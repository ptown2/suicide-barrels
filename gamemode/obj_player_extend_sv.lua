local meta = FindMetaTable("Player")
if not meta then return end

function meta:SourceExplode( range )
	local explode = ents.Create( "env_explosion" )
	explode:SetPos( self:GetPos() )
	explode:SetOwner( self )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", range )
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 )
end