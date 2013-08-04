local PLAYER = {}

PLAYER.DisplayName			= "Human"

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 270
PLAYER.MaxHealth			= 100

function PLAYER:HUDPaint()
	local health = math.max( 0, MySelf:Health() )
	if ( GAMEMODE:GetState() == STATE_PLAYING ) then
		draw.DrawText( "Survive 'til the end!", "SB_TextMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	end

	draw.DrawText( health, "SB_TextBHuge", 64, H - 96, HSVToColor( ( health / 100 ) * 130, 1, 1 ), TEXT_ALIGN_LEFT )
end

function PLAYER:CalcView( pl, origin, angles, fov )
	local view = {}
	view.origin = origin
	view.angles = angles
	view.fov = fov

	return view
end

function PLAYER:ShouldDrawLocalPlayer()
	return false
end

function PLAYER:OnSpawn( pl )
	local desiredname = pl:GetInfo("cl_playermodel")
	if #desiredname == 0 then
		pl:SetModel( "models/player/alyx.mdl" )		--Just incase the player has NO model selected.
	else
		pl:SetModel( player_manager.TranslatePlayerModel( desiredname ) )
	end

	local pcol = Vector( pl:GetInfo( "cl_playercolor" ) ) 
	pcol.x = math.Clamp( pcol.x, 0, 2.5 )
	pcol.y = math.Clamp( pcol.y, 0, 2.5 )
	pcol.z = math.Clamp( pcol.z, 0, 2.5 )
	pl:SetPlayerColor( pcol )

	local wcol = Vector( pl:GetInfo( "cl_weaponcolor" ) )
	wcol.x = math.Clamp( wcol.x, 0, 2.5 )
	wcol.y = math.Clamp( wcol.y, 0, 2.5 )
	wcol.z = math.Clamp( wcol.z, 0, 2.5 )
	pl:SetWeaponColor( wcol )

	pl:SetWalkSpeed( self.WalkSpeed )
	pl:SetRunSpeed( self.RunSpeed )
	pl:SetMaxHealth( self.MaxHealth )
	pl:SetHealth( pl:GetMaxHealth() )
	--pl:ResetHull()
end

function PLAYER:OnLoadout( pl )
	pl:SetAmmo( 9999, "pistol" )
	pl:Give( "weapon_sb_pistol" )
end

function PLAYER:CanSuicide( pl )
	return ( GAMEMODE:GetState() == STATE_PLAYING )
end

function PLAYER:OnPlayerDeath( pl, attacker )
	pl:CreateRagdoll()

	if ( GAMEMODE:GetState() == STATE_PLAYING ) then
		pl:SetTeam( TEAM_OIL )
	end
end

function PLAYER:GetHandsModel( pl )
	local cl_playermodel = self.Player:GetInfo( "cl_playermodel" )
	return player_manager.TranslatePlayerHands( cl_playermodel )
end

function PLAYER:OnKeyPress( pl, key ) end

player_manager.RegisterClass( "class_human", PLAYER, "class_default" )