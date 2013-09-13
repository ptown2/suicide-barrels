function GM:AddResources()
	--resource.AddFile()
	--resource.AddWorkshop() --Soon
end

function GM:AddNetworkStrings()
	util.AddNetworkString( "sb_sendstate" )
	util.AddNetworkString( "sb_sendtime" )
	util.AddNetworkString( "sb_teamwinner" )
	util.AddNetworkString( "sb_broadmusic" )
end

function GM:SetupSpawns()
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetSpawnPoint( TEAM_BARREL, { "info_player_start", "info_player_counterterrorist", "info_player_combine" } )
end