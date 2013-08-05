local MapChange = false

function GM:CallStateFunction( state, stype, ... )
	local state = self.STATES[ state ]
	local metaFunc = state[ stype ]

	if ( state && metaFunc ) then
		metaFunc( self, ... )
	end
end

GM.STATES = {}
GM.STATES[STATE_NONE]		= {}
GM.STATES[STATE_WAITING]	= {}
GM.STATES[STATE_PREPARING]	= {}
GM.STATES[STATE_PLAYING]	= {}
GM.STATES[STATE_ENDING]		= {}
GM.STATES[STATE_MAPCHANGE]	= {}

-- None States
GM.STATES[STATE_NONE].Start = function( self )
	self.TimeLeft = nil
end
GM.STATES[STATE_NONE].End = function( self )
	self.TimeLeft = nil
end

-- Waiting States
GM.STATES[STATE_WAITING].Start = function( self )
	util.ChatToPlayers( "Game Starting in 30 seconds." )
	self:AddTime( 30 )
end
GM.STATES[STATE_WAITING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		self:SetState( STATE_PREPARING )
	end
end
GM.STATES[STATE_WAITING].End = function( self )
	for _, pl in pairs( player.GetAll() ) do
		pl:SetTeam( TEAM_HUMAN )
		pl:KillSilent()
		pl:Spawn()
	end
end

-- Preparing States
GM.STATES[STATE_PREPARING].Start = function( self, laststate )
	if ( self.RoundsLeft == 1 ) && ( laststate ~= STATE_PLAYING ) then
		util.ChatToPlayers( "This is the last round!" )
	end

	if ( laststate == STATE_PLAYING ) then
		self.TimeLeft = self:GetTime() - CurTime()
	end

	self:BroadcastMusic( "music/stingers/industrial_suspense" ..math.random(1, 2).. ".wav" )
	self:AddTime( math.random( 7, 10 ) )
end
GM.STATES[STATE_PREPARING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		self:SetState( STATE_PLAYING )
	end
end
GM.STATES[STATE_PREPARING].End = function( self, state )
	if ( lasttate ~= STATE_PREPARING ) then
		self:SelectVictim()
	end
end

-- Playing States
GM.STATES[STATE_PLAYING].Start = function( self )
	self:BroadcastMusic( "music/HL2_song20_submix4.mp3", 45 )

	self:AddTime( self.TimeLeft || TIME_PLAYING )

	if ( #player.GetAll() <= 1 ) then self:EndRound( TEAM_HUMAN ) return end
end
GM.STATES[STATE_PLAYING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		self:CheckTeams()
	end
end

-- Ending States
GM.STATES[STATE_ENDING].Start = function( self )
	self.TimeLeft = nil
	self.RoundsLeft = math.max( 0, self.RoundsLeft - 1 )

	self:AddTime( TIME_END )
end
GM.STATES[STATE_ENDING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		if ( self.RoundsLeft <= 0 ) then
			self:SetState( STATE_MAPCHANGE )
		elseif ( #player.GetAll() >= 2 ) then
			self:SetState( STATE_PREPARING )
		elseif ( #player.GetAll() <= 1 ) then
			self:SetState( STATE_NONE )
		end
	end
end
GM.STATES[STATE_ENDING].End = function( self )
	game.CleanUpMap()

	for _, pl in pairs( player.GetAll() ) do
		pl:SetTeam( TEAM_HUMAN )
		pl:KillSilent()
		pl:Spawn()
	end
end

GM.STATES[STATE_MAPCHANGE].Start = function( self )
	hook.Call( "OnMapChange" )
	self:AddTime( TIME_MAPCHANGE )
end
GM.STATES[STATE_MAPCHANGE].Think = function( self )
	if ( self:GetTime() < CurTime() ) && !MapChange then
		hook.Call( "LoadNextMap" )
		MapChange = true
	end
end