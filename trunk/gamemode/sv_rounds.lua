function GM:SetState( state, timewait )
	self.STATES[ self:GetState() ].End( self )
	SetGlobalInt( "sb_state", state )
	self.STATES[ self:GetState() ].Start( self )
end

function GM:SetTime( time )
	SetGlobalFloat( "sb_time", time )
end

function GM:AddTime( fTime )
	SetGlobalFloat( "sb_time", CurTime() + fTime )
end

function GM:Think()
	self.STATES[ self:GetState() ].Think( self )
end

function GM:EndRound( teamid )
	self:SetState( STATE_ENDING )
end

function GM:CheckTeams()
	if ( self:GetState() ~= STATE_PLAYING ) then return end

	if ( self:GetTime() <= CurTime() ) && ( #team.GetPlayers( TEAM_HUMAN ) >= 1 ) then
		self:EndRound( TEAM_HUMAN )
		return
	end

	if ( #team.GetPlayers( TEAM_HUMAN ) <= 0 ) then
		self:EndRound( TEAM_OIL )
		return
	end

	if ( #team.GetPlayers( TEAM_OIL ) <= 0 ) && ( #team.GetPlayers( TEAM_HUMAN ) > 1 ) then
		self:SetState( STATE_PREPARING )
		return
	end
end
