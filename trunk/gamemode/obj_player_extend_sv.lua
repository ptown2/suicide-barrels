local meta = FindMetaTable("Player")
if !meta then return end

function meta:SourceExplode( range )
	local explode = ents.Create( "env_explosion" )
	explode:SetPos( self:GetPos() )
	explode:SetOwner( self )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", range )
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 )
end

function meta:GonnaExplode()
	return ( self:Alive() && self.IsExploding )
end

function meta:HandlePlayerModel()
	local desiredname = self:GetInfo("cl_playermodel")

	if ( #desiredname == 0 ) then
		self:SetModel( player_manager.TranslatePlayerModel( GAMEMODE.RandomPlayerModels[ math.random( #GAMEMODE.RandomPlayerModels ) ] ) )
	else
		self:SetModel( player_manager.TranslatePlayerModel( desiredname ) )
	end
end

function meta:HandleViewModel()
	local oldhands = self:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		self:SetHands( hands )
		hands:DoSetup( self )
		hands:Spawn()
 	end
 end
