local PLAYER = {}

PLAYER.DisplayName			= "Human"

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 290
PLAYER.MaxJumpPower			= 210
PLAYER.MaxHealth			= 100

function PLAYER:HUDPaint()
	CurrentHealth =  math.Approach( CurrentHealth or self.MaxHealth, MySelf:Health(), 0.5 )

	if ( GAMEMODE:GetState() == STATE_PLAYING ) then
		draw.DrawText( "Survive 'til the end!", "SB_TextMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	end

	--[[
	surface.SetTexture(health_back)
	surface.DrawTexturedRect(curX, curY - imagesizey, imagesizex, imagesizey)

	if health < maxhealth * 0.25 then
		colHealth.a = 255 - math.abs(math.sin(RealTime() * 4)) * 160
		surface.SetDrawColor(colHealth)
	end

	surface.SetTexture(health_bar)
	surface.DrawTexturedRectUV(curX, curY - imagesizey, (((health / maxhealth) * 368) + 96) * screens, imagesizey, imagesizex, imagesizey, 1, 1)
	]]

	draw.DrawText( math.floor( math.max( 0, CurrentHealth ) ), "SB_TextBHuge", 64, H - 96, HSVToColor( ( math.max( 0, CurrentHealth ) / self.MaxHealth ) * 130, 1, 1 ), TEXT_ALIGN_LEFT )
end

function PLAYER:CalcView( origin, angles, fov )
	local view = {}
	view.origin = origin
	view.angles = angles
	view.fov = fov

	return view
end

function PLAYER:ShouldDrawLocalPlayer()
	return false
end

function PLAYER:OnThink()
	if ( self.Player:WaterLevel() >= 2 ) then
		if ( self.Player.NextHurt < CurTime() ) then
			self.Player:TakeDamage( 5 )
			self.Player:EmitSound( Sound( "player/pl_drown" .. math.random( 1, 3 ) .. ".wav" ) )
			self.Player:ViewPunch( Angle( math.Rand( -5, 5 ), math.Rand( -5, 5 ), math.Rand( -10, 10 ) ) )
			self.Player.NextHurt = CurTime() + 1
		end
	else
		if ( !GAMEMODE.LeechesEnabled ) then
			self.Player.NextHurt = CurTime() + 10
		end
	end
end

function PLAYER:OnSpawn()
	self.Player:HandlePlayerModel()
	self.Player:HandleViewModel()

	local pcol = Vector( self.Player:GetInfo( "cl_playercolor" ) ) 
	pcol.x = math.Clamp( pcol.x, 0, 2.5 )
	pcol.y = math.Clamp( pcol.y, 0, 2.5 )
	pcol.z = math.Clamp( pcol.z, 0, 2.5 )
	self.Player:SetPlayerColor( pcol )

	local wcol = Vector( self.Player:GetInfo( "cl_weaponcolor" ) )
	wcol.x = math.Clamp( wcol.x, 0, 2.5 )
	wcol.y = math.Clamp( wcol.y, 0, 2.5 )
	wcol.z = math.Clamp( wcol.z, 0, 2.5 )
	self.Player:SetWeaponColor( wcol )

	self.Player:SetWalkSpeed( self.WalkSpeed )
	self.Player:SetRunSpeed( self.RunSpeed )
	self.Player:SetJumpPower( self.MaxJumpPower )
	self.Player:SetMaxHealth( self.MaxHealth )
	self.Player:SetHealth( self.Player:GetMaxHealth() )

	self.Player.NextHurt = 0
	--self.Player:ResetHull()
end

function PLAYER:OnLoadout()
	self.Player:SetAmmo( 9999, "pistol" )
	self.Player:Give( "weapon_sb_pistol" )
end

function PLAYER:CanSuicide()
	return ( GAMEMODE:GetState() == STATE_PLAYING )
end

function PLAYER:OnPlayerDeath( attacker )
	self.Player:CreateRagdoll()

	if ( GAMEMODE:GetState() == STATE_PLAYING ) then
		self.Player:SetTeam( TEAM_OIL )
	end
end

function PLAYER:OnKeyPress( key ) end
function PLAYER:OnKeyRelease( key ) end

player_manager.RegisterClass( "class_human", PLAYER, "class_default" )