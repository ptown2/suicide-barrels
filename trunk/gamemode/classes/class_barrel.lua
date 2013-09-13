local PLAYER = {}

PLAYER.DisplayName			= "Barrel"

PLAYER.WalkSpeed 			= 180
PLAYER.RunSpeed				= 285
PLAYER.MaxJumpPower			= 250
PLAYER.MaxHealth			= 1

function PLAYER:HUDPaint()
	if ( GAMEMODE:GetState() == STATE_PLAYING ) then
		draw.DrawText( "Eliminate the humans!", "SB_TextMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		for _, pl in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
			local pos = pl:LocalToWorld( pl:OBBCenter() )
			local dpos = pos:ToScreen()

			draw.DrawText( pl:Health() .."%", "SB_TextBSmall", dpos.x, dpos.y - 16, HSVToColor( ( pl:Health() / 100 ) * 120, 1, 1 ), TEXT_ALIGN_CENTER )
		end

		draw.DrawText( "LMB to Allah - RMB to Taunt - Hold Shift to Sprint", "SB_TextMed", W / 2, H - 42, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
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

	self.Player:SetModel( table.Random( GAMEMODE.ValidBarrels ) )

	if GAMEMODE.BarrelSkins[ self.Player:GetModel() ] then
		self.Player:SetSkin( math.random( self.Player:SkinCount() ) )
	end

	self.Player:SetWalkSpeed( self.WalkSpeed )
	self.Player:SetRunSpeed( self.RunSpeed )
	self.Player:SetMaxHealth( self.MaxHealth )
	self.Player:SetHealth( self.Player:GetMaxHealth() )

	self.Player.CanExplode = CurTime() + 1.25
	self.Player.CanTaunt = CurTime() + 1
	self.Player.IsExploding = false
	self.Player.SetPhase = false
	self.Player.ExplosionPower = 100

	--[[local plmin, plmax = self.Player:OBBMins(), self.Player:OBBMaxs()
	self.Player:SetHull( plmin, plmax )
	self.Player:SetHullDuck( plmin, plmax )]]
end

function PLAYER:OnKeyPress( key )
	if ( key == IN_ATTACK ) && ( self.Player.CanExplode <= CurTime() ) then
		self.Player.IsExploding = true
	elseif ( key == IN_ATTACK2 ) && ( self.Player.CanTaunt <= CurTime() ) then
		self.Player:EmitSound( table.Random( GAMEMODE.TAUNTS ), 105, math.random( 150, 175 ) )
		self.Player.CanTaunt = CurTime() + 1.3
	end
end

function PLAYER:OnThink()
	if self.Player.IsExploding then
		if ( self.Player.ExplosionPower == 100 ) then
			self.Player:EmitSound( "suicidebarrels/jihad.wav", 100, math.random( 150, 175 ) )
		end

		self.Player.ExplosionPower = self.Player.ExplosionPower + 0.4
	end

	if ( self.Player.ExplosionPower >= 126 ) && !self.Player.SetPhase then
		self.Player:EmitSound( "Weapon_CombineGuard.Special1" )
		self.Player.SetPhase = true
	end

	if ( self.Player.ExplosionPower >= 152 ) then
		self.Player:KillSilent()
		self.Player:SourceExplode( 152 )
	end
end

function PLAYER:CanSuicide()
	return false
end

function PLAYER:OnPlayerDeath( attacker )
	if ( self.Player ~= attacker ) then
		self.Player:SourceExplode( self.Player.ExplosionPower or 100 )
	end
end

function PLAYER:OnLoadout() end
function PLAYER:OnKeyRelease( key ) end

player_manager.RegisterClass( "class_barrel", PLAYER, "class_default" )