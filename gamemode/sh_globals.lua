STATE_NONE		= 0
STATE_WAITING	= 1
STATE_PREPARING	= 2
STATE_PLAYING	= 3
STATE_ENDING	= 4
STATE_MAPCHANGE	= 5

TIME_WAIT		= 45
TIME_PLAYING	= 150
TIME_MAPCHANGE	= 35
TIME_END		= 10
BAR_PER_HUM		= 10
ROUND_LIMIT		= 6

TEAM_HUMAN		= 1
TEAM_SURVIVOR	= TEAM_HUMAN

TEAM_OIL		= 2
TEAM_BARREL		= TEAM_OIL
TEAM_BARRELS	= TEAM_BARREL

TEAM_TIE		= 3

function GM:GetState()
	return GetGlobalInt( "sb_state", 1 )
end

function GM:GetRound()
	return GetGlobalInt( "sb_round", ROUND_LIMIT )
end

function GM:GetTime()
	return GetGlobalFloat( "sb_time", 0 )
end

function GM:GetTeamWinner()
	return GetGlobalInt( "sb_teamwin", 2 )
end

GM.RoundsLeft		= ROUND_LIMIT
GM.MaxRounds		= ROUND_LIMIT
GM.SpawnDistance	= 1024
GM.LeechesEnabled	= false

GM.PropSpawns = {
	"prop_dynamic",
	"prop_physics"
}

GM.Taunts = {
	"vo/npc/male01/behindyou01.wav",
	"vo/npc/male01/behindyou02.wav",
	"vo/npc/male01/zombies01.wav",
	"vo/npc/male01/watchout.wav",
	"vo/npc/male01/upthere01.wav",
	"vo/npc/male01/upthere02.wav",
	"vo/npc/male01/thehacks01.wav",
	"vo/npc/male01/strider_run.wav",
	"vo/npc/male01/runforyourlife01.wav",
	"vo/npc/male01/runforyourlife02.wav",
	"vo/npc/male01/runforyourlife03.wav",
}

GM.ValidBarrels = {
	"models/props_phx/facepunch_barrel.mdl",
	"models/props_c17/oildrum001_explosive.mdl",
	//"models/props_borealis/bluebarrel001.mdl",
	"models/props_c17/oildrum001.mdl",
	"models/props_phx/oildrum001_explosive.mdl",
}

-- If a person has no player model then use one of these.
GM.RandomPlayerModels = {}
for name, mdl in pairs( player_manager.AllValidModels() ) do
	table.insert( GM.RandomPlayerModels, name )
end

team.SetUp( TEAM_HUMAN, "Humans", Color (0, 255, 0, 255) )
team.SetUp( TEAM_OIL, "Barrels", Color (255, 0, 0, 255) )