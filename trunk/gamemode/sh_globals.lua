function GM:GetState()
	return GetGlobalInt( "sb_state", 1 )
end

function GM:GetTime()
	return GetGlobalFloat( "sb_time", 0 )
end

function GM:GetTeamWinner()
	return GetGlobalInt( "sb_teamwin", 2 )
end

STATE_NONE		= 0
STATE_WAITING	= 1
STATE_PREPARING	= 2
STATE_PLAYING	= 3
STATE_ENDING	= 4

TIME_PLAYING	= 150
TIME_END		= 10
ROUND_LIMIT		= 10

TEAM_HUMAN		= 1
TEAM_SURVIVOR	= TEAM_HUMAN

TEAM_OIL		= 2
TEAM_BARREL		= TEAM_OIL
TEAM_BARRELS	= TEAM_BARREL

team.SetUp( TEAM_HUMAN, "Humans", Color (0, 255, 0, 255) )
team.SetUp( TEAM_OIL, "Barrels", Color (255, 0, 0, 255) )