GM.STATES = {}

STATE_NONE		= 0
STATE_WAITING	= 1
STATE_PREPARING	= 2
STATE_PLAYING	= 3
STATE_ENDING	= 4

-- None States
GM.STATES[STATE_NONE].Start = function( self ) end

GM.STATES[STATE_NONE].Think = function( self ) end

GM.STATES[STATE_NONE].End = function( self ) end

-- Waiting States
GM.STATES[STATE_WAITING].Start = function( self ) end

GM.STATES[STATE_WAITING].Think = function( self ) end

GM.STATES[STATE_WAITING].End = function( self ) end

-- Preparing States
GM.STATES[STATE_PREPARING].Start = function( self ) end

GM.STATES[STATE_PREPARING].Think = function( self ) end

GM.STATES[STATE_PREPARING].End = function( self ) end

-- Playing States
GM.STATES[STATE_PLAYING].Start = function( self ) end

GM.STATES[STATE_PLAYING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		self:CheckTeams()
	end
end

GM.STATES[STATE_PLAYING].End = function( self ) end

-- Ending States
GM.STATES[STATE_ENDING].Start = function( self ) end

GM.STATES[STATE_ENDING].Think = function( self ) end

GM.STATES[STATE_ENDING].End = function( self ) end