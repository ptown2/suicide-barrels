local MapChange = false

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
GM.STATES[STATE_NONE].DrawHUD = function( self )
	local t = RealTime() * 1.5

	draw.TextRotated( "Requires 2 or more to start. Invite some!", W / 2, H * 0.20, color_white, "SB_TextBHuge", 5 * math.sin( t ) )
end

-- Waiting States
GM.STATES[STATE_WAITING].Start = function( self )
	util.ChatToPlayers( "Game Starting in ".. TIME_WAIT .." seconds." )
	self:SetTime( TIME_WAIT )
end
GM.STATES[STATE_WAITING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		self:SetState( STATE_PREPARING )
	end
end
GM.STATES[STATE_WAITING].End = function( self )
	for _, pl in pairs( player.GetAll() ) do
		pl:SetTeam( TEAM_HUMAN )
		pl:Spawn()
	end
end
GM.STATES[STATE_WAITING].DrawHUD = function( self )
	local t = RealTime() * 1.5

	draw.TextRotated( "Waiting for more players...", W / 2, H * 0.20, color_white, "SB_TextBHuge", 5 * math.sin( t ) )
	draw.DrawText( self:GetRealTime(), "SB_TextBHuge", W / 2, H * 0.26, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end

-- Preparing States
GM.STATES[STATE_PREPARING].Start = function( self, laststate )
	if ( self:GetRoundsLeft() == 1 ) && ( laststate ~= STATE_PLAYING ) then
		util.ChatToPlayers( "This is the final round!" )
	end

	if ( laststate == STATE_PLAYING ) then
		self.TimeLeft = math.abs( self:GetTime() - CurTime() )
	end

	self:SetTime( math.random( 9, 12 ) )
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
GM.STATES[STATE_PREPARING].DrawHUD = function( self )
	draw.DrawText( "Selecting a victim...", "SB_TextBMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
end

-- Playing States
GM.STATES[STATE_PLAYING].Start = function( self )
	self:SetTime( self.TimeLeft || TIME_PLAYING )

	if ( #player.GetAll() <= 1 ) then self:EndRound( TEAM_HUMAN ) return end
end
GM.STATES[STATE_PLAYING].Think = function( self )
	if ( self:GetTime() < CurTime() ) then
		self:CheckTeams()
	end
end
GM.STATES[STATE_PLAYING].DrawHUD = function( self )
	draw.DrawText( "Round " ..( self.MaxRounds - self:GetRoundsLeft()+1 ).. " of " ..self.MaxRounds, "SB_TextBMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	draw.DrawText( "Time Remaining: " ..util.ToMinutesSeconds( self:GetRealTime() ), "SB_TextBMed", 16, 44, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

	draw.DrawText( "H: " ..#team.GetPlayers( TEAM_HUMAN ), "SB_TextBMed", 16, 72, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	draw.DrawText( "B: " ..#team.GetPlayers( TEAM_OIL ), "SB_TextBMed", 148, 72, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
end

-- Ending States
GM.STATES[STATE_ENDING].Start = function( self )
	self.LastHuman = nil
	self.TimeLeft = nil
	self:SetRounds( math.max( 0, self:GetRoundsLeft() - 1 ) )

	self:SetTime( TIME_END )
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
	self:RandomizeBarrels()

	if ( self:GetRoundsLeft() ~= 0 ) then
		for _, pl in pairs( player.GetAll() ) do
			pl:SetTeam( TEAM_HUMAN )
			pl:Spawn()
		end
	end
end
GM.STATES[STATE_ENDING].DrawHUD = function( self )
	local t = RealTime() * 1.5

	if ( self:GetTeamWinner() == TEAM_HUMAN ) then
		draw.TextRotated( "The humans have survived.", W/2, H * 0.20, color_white, "SB_TextBHuge", 10 * math.sin( t ) )
	elseif ( self:GetTeamWinner() == TEAM_OIL ) then
		draw.TextRotated( "The barrels have taken over the human race.", W/2, H * 0.20, color_white, "SB_TextBHuge", 5 * math.sin( t ) )
	end
end

GM.STATES[STATE_MAPCHANGE].Start = function( self )
	hook.Call( "OnMapChange" )
	self:SetTime( TIME_MAPCHANGE )
end
GM.STATES[STATE_MAPCHANGE].Think = function( self )
	if ( self:GetTime() < CurTime() ) && !MapChange then
		hook.Call( "LoadNextMap" )
		MapChange = true
	end
end
GM.STATES[STATE_MAPCHANGE].DrawHUD = function( self )
	draw.DrawText( "Next Map in: " ..util.ToMinutesSeconds( math.ceil( math.max( 0, self:GetTime() - CurTime() ) ) ), "SB_TextBMed", W / 2, H * 0.80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end