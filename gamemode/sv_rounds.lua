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
	if ( self:GetTime() >= CurTime() ) then
		self.STATES[ self:GetState() ].Think( self )
	end
end

function GM:SelectVictim()
	if ( self:GetState() == STATE_PLAYING ) then
		self.TimeLeft = GetTime() - CurTime()
		self:SetState( STATE_PREPARING )
	elseif ( self:GetState() == STATE_PREPARING ) then
		-- Do a player pick here.
	end
end

function GM:EndRound( teamid )
	self:SetState( STATE_ENDING )
end

function GM:CheckTeams()
	if ( self:GetState() ~= STATE_PLAYING ) then return end

	if ( #player.GetAll() >= 1 ) then
		if ( #team.GetPlayers( TEAM_HUMAN ) <= 0 ) then
			self:EndRound( TEAM_OIL )
		elseif ( #team.GetPlayers( TEAM_OIL ) <= 0 ) && ( #team.GetPlayers( TEAM_HUMAN ) > 1 ) then
			self:SelectVictim()
		else
			self:EndRound( TEAM_HUMAN )
		end
	else
		self:EndRound( TEAM_OIL )
	end
end
