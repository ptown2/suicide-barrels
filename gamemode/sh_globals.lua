/* Generic Globals */
STATE_NONE		= 0
STATE_WAITING	= 1
STATE_PREPARING	= 2
STATE_PLAYING	= 3
STATE_ENDING	= 4
STATE_MAPCHANGE	= 5
STATE_LASTHUMAN = 99

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
TEAM_NOWINS		= TEAM_TIE

/* Gamemode Globals */
GM.State			= STATE_NONE
GM.Time				= TIME_WAIT
GM.TeamWinner		= TEAM_TIE
GM.RoundsLeft		= ROUND_LIMIT
GM.MaxRounds		= ROUND_LIMIT

GM.MinSpawnDistance	= 512
GM.MaxSpawnDistance	= 1024

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

GM.MapHandling = {
	["sb_cookies_barrelmania"] = { Min = 256, Max = 768, Leeches = true  },
	["sb_maze"] = { Min = 128, Max = 512, Leeches = false },
	["sb_shitbox"] = { Min = 256, Max = 768, Leeches = false },
}

GM.MusicID = {
	[STATE_WAITING] = { "music/HL1_song17.mp3", 90, true },

	[STATE_PREPARING] = {
		{ "music/stingers/industrial_suspense1.wav", 90 },
		{ "music/stingers/industrial_suspense2.wav", 90 },
		{ "music/Ravenholm_1.mp3", 85 },
	},

	[STATE_PLAYING] = {
		{ "music/HL2_song20_submix0.mp3", 50, true },
		{ "music/HL2_song20_submix4.mp3", 45, true },
	},

	[STATE_ENDING] = {
		[TEAM_HUMAN] = { "music/HL1_song25_REMIX3.mp3", 90 }, 
		[TEAM_OIL] = {
			{ "music/stingers/HL1_stinger_song7.mp3", 90 },
			{ "music/stingers/HL1_stinger_song8.mp3", 90 },
			{ "music/stingers/HL1_stinger_song16.mp3", 90 },
			{ "music/stingers/HL1_stinger_song27.mp3", 90 },
		},
	},

	[STATE_LASTHUMAN] = {
		{ "music/HL2_song12_long.mp3", 70, true },
		{ "music/HL1_song19.mp3", 70, true },
	},
}

GM.ValidBarrels = {
	"models/props_phx/facepunch_barrel.mdl",
	"models/props_c17/oildrum001_explosive.mdl",
	//"models/props_borealis/bluebarrel001.mdl",
	"models/props_c17/oildrum001.mdl",
	"models/props_phx/oildrum001_explosive.mdl",
}

GM.TrueBarrels = {
	["models/props_phx/facepunch_barrel.mdl"] = true,
	["models/props_c17/oildrum001_explosive.mdl"] = true,
	["models/props_c17/oildrum001.mdl"] = true,
	["models/props_phx/oildrum001_explosive.mdl"] = true,
}

-- If a person has no player model then use one of these.
GM.RandomPlayerModels = {}
for name, _ in pairs( player_manager.AllValidModels() ) do
	table.insert( GM.RandomPlayerModels, name )
end

/* Get Variable Functions */
function GM:GetState()
	return self.State
end

function GM:GetRoundsLeft()
	return self.RoundsLeft
end

function GM:GetTime()
	return self.Time
end

function GM:GetRealTime()
	return math.ceil( math.max( 0, self:GetTime() - CurTime() ) )
end

function GM:GetTeamWinner()
	return self.TeamWinner
end


/* Set up the teams */
team.SetUp( TEAM_HUMAN, "Humans", Color (0, 255, 0, 255) )
team.SetUp( TEAM_OIL, "Barrels", Color (255, 0, 0, 255) )