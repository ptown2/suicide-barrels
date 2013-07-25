function GM:GetState()
	return GetGlobalInt( "sb_state", 1 )
end

function GM:GetTime()
	return GetGlobalFloat( "sb_time", 0 )
end

GM.TAUNTS = {
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

TEAM_HUMAN		= 1
TEAM_SURVIVOR	= TEAM_HUMAN

TEAM_OIL		= 2
TEAM_BARREL		= TEAM_OIL
TEAM_BARRELS	= TEAM_BARREL

team.SetUp( TEAM_HUMAN, "Humans", Color (0, 255, 0, 255) )
team.SetUp( TEAM_OIL, "Barrels", Color (255, 0, 0, 255) )