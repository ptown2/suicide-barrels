-- Set Global Vars
function GM:SetState( state, timewait )
	local laststate = self:GetState()

	self:CallStateFunction( laststate, "End", state )
	self:CallStateFunction( state, "Start", laststate )
	self.State = state

	net.Start( "sb_syncstate" )
		net.WriteInt( self.State, 4 )
	net.Broadcast()
end

function GM:SetRounds( rounds )
	self.RoundsLeft = rounds

	net.Start( "sb_syncrounds" )
		net.WriteInt( self.RoundsLeft, 8 )
	net.Broadcast()
end

function GM:SetTeamWin( teamid )
	self.TeamWinner = teamid

	net.Start( "sb_syncteam" )
		net.WriteInt( self.TeamWinner, 4 )
	net.Broadcast()
end

function GM:SetTime( time )
	self.Time = math.floor( CurTime() ) + math.floor( time )

	net.Start( "sb_synctime" )
		net.WriteInt( self.Time, 16 )
	net.Broadcast()
end

function GM:AddTime( fTime )
	self.Time = self.Time + math.floor( fTime )

	net.Start( "sb_synctime" )
		net.WriteInt( self.Time, 16 )
	net.Broadcast()
end

-- Round Management
function GM:EndRound( teamid )
	self:SetTeamWin( teamid )
	self:SetState( STATE_ENDING )
end

function GM:SelectVictim()
	local barrels = {}
	local numbarrels = math.ceil( #team.GetPlayers( TEAM_HUMAN ) / BAR_PER_HUM )

	if ( #team.GetPlayers( TEAM_HUMAN ) <= 1 ) then return end
	if ( #team.GetPlayers( TEAM_OIL ) >= numbarrels ) then return end

	for i = 1, numbarrels do
		local victim = table.Random( team.GetPlayers( TEAM_HUMAN ) )
		victim:SetTeam( TEAM_OIL )
		victim:Spawn()

		table.insert( barrels, victim:Name() )
	end

	util.ChatToPlayers( util.AndSeparate( barrels ) .. ( #barrels > 1 && " have turned into barrels. Watch out!" || " has turned into a barrel. Watch out!" ) )
end

function GM:SetLastHuman( pl )
	self.LastHuman = pl

	pl:StripWeapons()
	pl:StripAmmo()

	pl:SetHealth( pl:GetMaxHealth() )
	pl:SetAmmo( 9999, "pistol" )
	pl:Give( "weapon_sb_last" )

	util.BroadcastLua( "GAMEMODE:RunMusic(  ".. STATE_LASTHUMAN .." )")
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

	if ( thumanc == 1 ) && ( tbarrelc >= 2 ) && ( !self.LastHuman || !IsValid( self.LastHuman ) ) then
		local lasthum = team.GetPlayers( TEAM_HUMAN )[1]

		util.ChatToPlayers( lasthum:Name().. " is the last human! Don't let it escape!" )
		self:SetLastHuman( lasthum )
		return
	end

	-- Check if the time is over and there are survivors or no humans left to turn into barrels.
	if ( ( self:GetTime() <= CurTime() ) && (thumanc >= 1) ) || ( ( tbarrelc <= 0 ) && ( thumanc <= 1 ) ) then
		util.ChatToPlayers( "The humans have survived." )
		self:EndRound( TEAM_HUMAN )
		return
	end

	-- What if the previous barrel left?
	if ( tbarrelc <= 0 ) && ( thumanc > 1 ) then
		util.ChatToPlayers( "All of the barrels left the game. Picking another victim." )
		self:SetState( STATE_PREPARING )
		return
	end

	-- What if everyone died?
	if ( thumanc <= 0 ) then
		util.ChatToPlayers( "The barrels have taken over the human race." )
		self:EndRound( TEAM_OIL )
		return
	end

	-- What if nobody's here?
	if ( thumanc <= 0 ) && ( tbarrelc <= 0 ) then
		self:EndRound( TEAM_TIE )
		return
	end
end
