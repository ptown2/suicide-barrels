STATE_NONE		= 0
STATE_WAITING	= 1
STATE_PREPARING	= 2
STATE_PLAYING	= 3
STATE_ENDING	= 4

GM.STATES = {}
GM.STATES[STATE_NONE]		= {}
GM.STATES[STATE_WAITING]	= {}
GM.STATES[STATE_PREPARING]	= {}
GM.STATES[STATE_PLAYING]	= {}
GM.STATES[STATE_ENDING]		= {}

function GM:CallStateFunction( state, stype, ... )
	local state = self.STATES[ state ]
	local metaFunc = state[ stype ]

	if ( state && metaFunc ) then
		metaFunc( self, ... )
	end
end

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
		pl:SetHealth( pl:GetMaxHealth() )
		
		if !pl:Alive() then
			pl:KillSilent()
			pl:Spawn()
		end
	end
end

-- Preparing States
GM.STATES[STATE_PREPARING].Start = function( self, laststate )
	if ( laststate == STATE_PLAYING ) then
		self.TimeLeft = self:GetTime() - CurTime()
	end

	self:AddTime( math.random( 4, 8 ) )
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
	self:AddTime( self.TimeLeft || TIME_PLAYING )
end
GM.STATES[STATE_PLAYING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		self:CheckTeams()
	end
end

-- Ending States
GM.STATES[STATE_ENDING].Start = function( self )
	self:AddTime( TIME_END )
end
GM.STATES[STATE_ENDING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		if ( #player.GetAll() >= 2 ) then
			self:SetState( STATE_PREPARING )
		else
			self:SetState( STATE_NONE )
		end
	end
end
GM.STATES[STATE_ENDING].End = function( self )
	self.TimeLeft = nil

	for _, pl in pairs( player.GetAll() ) do
		pl:SetTeam( TEAM_HUMAN )
		pl:SetHealth( pl:GetMaxHealth() )

		if !pl:Alive() then
			pl:KillSilent()
			pl:Spawn()
		end
	end
end