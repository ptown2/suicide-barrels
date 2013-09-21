net.Receive( "sb_syncdata", function( len )
	local state, time, rounds, winner = net.ReadInt( 4 ), net.ReadInt( 16 ), net.ReadInt( 8 ), net.ReadInt( 4 )

	GAMEMODE.State			= state
	GAMEMODE.Time			= time
	GAMEMODE.RoundsLeft		= rounds
	GAMEMODE.TeamWinner		= winner

	GAMEMODE:RunMusic( state )
end )

net.Receive( "sb_syncstate", function( len )
	local state = net.ReadInt( 4 )

	GAMEMODE.State			= state

	GAMEMODE:RunMusic( state )
end )

net.Receive( "sb_synctime", function( len )
	local time = net.ReadInt( 16 )

	GAMEMODE.Time			= time
end )

net.Receive( "sb_syncteam", function( len )
	local winner = net.ReadInt( 4 )

	GAMEMODE.TeamWinner		= winner
end )

net.Receive( "sb_syncrounds", function( len )
	local rounds = net.ReadInt( 8 )

	GAMEMODE.RoundsLeft		= rounds
end )