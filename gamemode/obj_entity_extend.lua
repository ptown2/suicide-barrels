local meta = FindMetaTable( "Entity" )
if !meta then return end

local function nocollidetimer( self, timername )
	if IsValid( self ) then
		for _, e in pairs( ents.FindInBox( self:WorldSpaceAABB() ) ) do
			if ( e:IsPlayer() && ( e ~= self ) ) then
				self:SetCollisionGroup( COLLISION_GROUP_WORLD )
				return
			end
		end

		self:SetCollisionGroup( COLLISION_GROUP_NONE )
	end

	timer.Destroy( timername )
end

function meta:TemporaryNoCollide()
	for _, e in pairs( ents.FindInBox( self:WorldSpaceAABB() ) ) do
		if ( e:IsPlayer() && ( e ~= self ) ) then
			self:SetCollisionGroup( COLLISION_GROUP_WORLD )

			local timername = "TemporaryNoCollide" ..self:EntIndex()
			timer.Create( timername, 0, 0, function() nocollidetimer( self, timername ) end )

			return
		end
	end

	self:SetCollisionGroup( COLLISION_GROUP_NONE )
end