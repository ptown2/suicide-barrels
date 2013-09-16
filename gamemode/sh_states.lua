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
	draw.DrawText( "Requires 2 or more to start. Invite some!", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end

-- Waiting States
GM.STATES[STATE_WAITING].Start = function( self )
	util.ChatToPlayers( "Game Starting in ".. TIME_WAIT .." seconds." )
	self:AddTime( TIME_WAIT )
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
	draw.DrawText( "Waiting for more players...", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	draw.DrawText( math.ceil( math.max( 0, self:GetTime() - CurTime() ) ), "SB_TextBHuge", W / 2, H * 0.26, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end

-- Preparing States
GM.STATES[STATE_PREPARING].Start = function( self, laststate )
	if ( self.RoundsLeft == 1 ) && ( laststate ~= STATE_PLAYING ) then
		util.ChatToPlayers( "This is the last round!" )
	end

	if ( laststate == STATE_PLAYING ) then
		self.TimeLeft = self:GetTime() - CurTime()
	end

	self:BroadcastMusic( "music/stingers/industrial_suspense" ..math.random(1, 2).. ".wav", 90 )
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
GM.STATES[STATE_PREPARING].DrawHUD = function( self )
	draw.DrawText( "Selecting a victim...", "SB_TextBMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
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
GM.STATES[STATE_PLAYING].DrawHUD = function( self )
	draw.DrawText( "Time Remaining: " ..util.ToMinutesSeconds( math.ceil( math.max( 0, self:GetTime() - CurTime() ) ) ), "SB_TextBMed", 16, 44, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

	draw.DrawText( "Humans: " ..#team.GetPlayers( TEAM_HUMAN ), "SB_TextBMed", W - 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	draw.DrawText( "Barrels: " ..#team.GetPlayers( TEAM_OIL ), "SB_TextBMed", W - 16, 44, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
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
	self:RandomizeBarrels()

	if ( self.RoundsLeft ~= 0 ) then
		for _, pl in pairs( player.GetAll() ) do
			pl:SetTeam( TEAM_HUMAN )
			pl:Spawn()
		end
	end
end
GM.STATES[STATE_ENDING].DrawHUD = function( self )
	local t = RealTime() * 1.5

	if ( self:GetTeamWinner() == TEAM_HUMAN ) then
		local t = RealTime() * 1.5
		draw.TextRotated( "The humans have survived.", W/2, H * 0.20, color_white, "SB_TextBHuge", 10 * math.sin( t ) )
		//draw.DrawText( "The humans have survived.", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	elseif ( self:GetTeamWinner() == TEAM_OIL ) then
		draw.TextRotated( "The barrels have taken over the human race.", W/2, H * 0.20, color_white, "SB_TextBHuge", 5 * math.sin( t ) )
		//draw.DrawText( "The barrels have taken over the human race.", "SB_TextBHuge", W / 2, H * 0.20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
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
GM.STATES[STATE_MAPCHANGE].DrawHUD = function( self )
	draw.DrawText( "Next Map in: " ..util.ToMinutesSeconds( math.ceil( math.max( 0, self:GetTime() - CurTime() ) ) ), "SB_TextBMed", W / 2, H * 0.80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end