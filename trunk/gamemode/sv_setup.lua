function GM:AddResources()
	resource.AddWorkshop( "178011330" )

	--resource.AddFile( "sound/suicidebarrels/jihad.wav" )
end

function GM:AddNetworkStrings()
	util.AddNetworkString( "sb_sendstate" )
	util.AddNetworkString( "sb_sendtime" )
	util.AddNetworkString( "sb_teamwinner" )
	util.AddNetworkString( "sb_broadmusic" )
end

function GM:SetupSpawns()
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetSpawnPoint( TEAM_BARREL, self.PropSpawns )
end

//{ "info_player_start", "info_player_counterterrorist", "info_player_combine" }