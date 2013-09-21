local PLAYER = {}

PLAYER.DisplayName			= "Normal Barrel"

PLAYER.WalkSpeed 			= 175
PLAYER.RunSpeed				= 300
PLAYER.MaxJumpPower			= 260
PLAYER.StartRange			= 90
PLAYER.MaxRange				= 140
PLAYER.MaxHealth			= 5

function PLAYER:HUDPaint()
	if ( GAMEMODE:GetState() == STATE_PLAYING ) then
		for _, pl in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
			local pos = pl:LocalToWorld( pl:OBBCenter() )
			local dpos = pos:ToScreen()

			draw.DrawText( pl:Health() .."%", "SB_TextBSmall", dpos.x, dpos.y - 16, HSVToColor( ( pl:Health() / 100 ) * 120, 1, 1 ), TEXT_ALIGN_CENTER )
		end

		draw.DrawText( "LMB to Allah - RMB to Taunt - Hold Shift to Sprint - R to Suicide Unstuck", "SB_TextMed", W / 2, H - 42, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
end

function PLAYER:CalcView( origin, angles, fov )
	local view = {}
	view.origin = GAMEMODE:SetThirdPerson( self.Player, origin, angles )
	view.angles = angles
	view.fov = fov

	return view
end

function PLAYER:ShouldDrawLocalPlayer()
	return true
end

function PLAYER:OnSpawn()
	local oldhands = self.Player:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	self.Player:SetWalkSpeed( self.WalkSpeed )
	self.Player:SetRunSpeed( self.RunSpeed )
	self.Player:SetJumpPower( self.MaxJumpPower )
	self.Player:SetMaxHealth( self.MaxHealth )
	self.Player:SetHealth( self.Player:GetMaxHealth() )

	self.Player.CanExplode = CurTime() + 1.5
	self.Player.CanTaunt = CurTime() + 1
	self.Player.IsExploding = false
	self.Player.SpawnPos = self.Player:GetPos()
	self.Player.SetPhase = false
	self.Player.ExplosionPower = self.StartRange

	self.Player.SpawnEnt:TemporaryNoCollide()
end

function PLAYER:OnKeyPress( key )
	local dist = 24

	if ( key == IN_ATTACK ) && ( self.Player.CanExplode <= CurTime() ) && ( !self.Player.IsExploding ) then
		if ( self.Player:GetPos():Distance( self.Player.SpawnPos ) >= dist ) then
			self.Player.IsExploding = true
		end
	elseif ( key == IN_ATTACK2 ) && ( self.Player.CanTaunt <= CurTime() ) then
		self.Player:EmitSound( table.Random( GAMEMODE.Taunts ), 95, math.random( 150, 175 ) )
		self.Player.CanTaunt = CurTime() + 1
	elseif ( key == IN_RELOAD ) then
		if ( self.Player:GetPos():Distance( self.Player.SpawnPos ) < dist * 1.25 ) then
			self.Player:KillSilent()
		end
	end
end

function PLAYER:OnThink()
	if self.Player.IsExploding then
		if ( self.Player.ExplosionPower == self.StartRange ) then
			self.Player:EmitSound( "suicidebarrels/jihad.wav", 75, math.random( 125, 150 ) )
		end

		self.Player.ExplosionPower = self.Player.ExplosionPower + 0.35
	end

	if ( self.Player.ExplosionPower >= ( self.MaxRange * 0.85 ) ) && !self.Player.SetPhase then
		self.Player:EmitSound( "Weapon_CombineGuard.Special1" )
		self.Player.SetPhase = true
	end

	if ( self.Player.ExplosionPower >= self.MaxRange ) then
		self.Player:KillSilent()
		self.Player:SourceExplode( self.MaxRange )
	end
end

function PLAYER:CanSuicide()
	return false
end

function PLAYER:OnPlayerDeath( attacker )
	if ( self.Player ~= attacker ) then
		self.Player:SourceExplode( math.max( self.StartRange, self.Player.ExplosionPower * 0.95 ) )
	end
end

function PLAYER:OnLoadout() end
function PLAYER:OnKeyRelease( key ) end

player_manager.RegisterClass( "class_barrel", PLAYER, "class_default" )