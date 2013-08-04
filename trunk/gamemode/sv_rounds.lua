-- Set Global Vars
function GM:SetState( state, timewait )
	local laststate = self:GetState()

	self:CallStateFunction( laststate, "End", state )
	self:CallStateFunction( state, "Start", laststate )
	SetGlobalInt( "sb_state", state )
end

function GM:SetTeamWin( teamid )
	SetGlobalInt( "sb_teamwin", teamid )
end

function GM:SetTime( time )
	SetGlobalFloat( "sb_time", time )
end

function GM:AddTime( fTime )
	SetGlobalFloat( "sb_time", CurTime() + fTime )
end

-- Round Management
function GM:EndRound( teamid )
	self:SetTeamWin( teamid )
	self:SetState( STATE_ENDING )
end

function GM:SelectVictim()
	if ( #team.GetPlayers( TEAM_HUMAN ) <= 1 ) then return end

	local victim = table.Random( player.GetAll() )
	victim:SetTeam( TEAM_OIL )
	victim:KillSilent()
	victim:Spawn()

	util.ChatToPlayers( victim:Name() .." has turned into a barrel. Watch out!" )
end

function GM:CheckTeams( pl )
	if ( self:GetState() ~= STATE_PLAYING ) then return end

	local thumanc, tbarrelc = #team.GetPlayers( TEAM_HUMAN ), #team.GetPlayers( TEAM_OIL )
	if IsValid( pl ) && pl:IsPlayer() then
		if ( pl:Team() == TEAM_HUMAN ) then
			thumanc = thumanc - 1
		else
			tbarrelc = tbarrelc - 1
		end
	end

	-- Check if the time is over and there are survivors or no humans left to turn into barrels.
	if ( ( self:GetTime() <= CurTime() ) && (thumanc >= 1) ) || ( ( tbarrelc <= 0 ) && ( thumanc <= 1 ) ) then
		util.ChatToPlayers( "The humans have survived." )
		self:EndRound( TEAM_HUMAN )
		self:BroadcastMusic( "music/HL1_song25_REMIX3.mp3" )
		return
	end

	-- What if the previous barrel left?
	if ( tbarrelc <= 0 ) && ( thumanc > 1 ) then
		util.ChatToPlayers( "The previous barrel has left the game. Picking another victim." )
		self:SetState( STATE_PREPARING )
		return
	end

	-- What if everyone died?
	if ( thumanc <= 0 ) then
		util.ChatToPlayers( "The barrels have taken over the human race." )
		self:EndRound( TEAM_OIL )
		self:BroadcastMusic( "music/stingers/HL1_stinger_song8.mp3" )
		return
	end

	-- What if nobody's here?
	if ( thumanc <= 0 ) && ( tbarrelc <= 0 ) then
		self:SetState( STATE_ENDING )
		return
	end
end
