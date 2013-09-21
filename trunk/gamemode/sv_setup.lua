function GM:AddResources()
	resource.AddWorkshop( "178011330" )
end

function GM:AddNetworkStrings()
	util.AddNetworkString( "sb_syncstate" )
	util.AddNetworkString( "sb_synctime" )
	util.AddNetworkString( "sb_syncteam" )
	util.AddNetworkString( "sb_syncrounds" )
	util.AddNetworkString( "sb_syncdata" )
end

function GM:SetupSpawns()
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetSpawnPoint( TEAM_OIL, self.PropSpawns )
end

function GM:RandomizeBarrels()
	for _, class in pairs( self.PropSpawns ) do
		for _, ent in pairs( ents.FindByClass( class ) ) do
			if ent:IsValidBarrel() then
				ent:SetModel( table.Random( self.ValidBarrels ) )
				ent:SetSkin( math.random( 0, ent:SkinCount() ) )

				ent:SetPos( ent:GetPos() + Vector( 0, 0, 16 ) )
				ent:SetAngles( Angle( 0, 0, 0 ) )

				ent:DropToFloor()
				ent:Activate()
				ent:Respawn()
			end
		end
	end
end

//{ "info_player_start", "info_player_counterterrorist", "info_player_combine" }