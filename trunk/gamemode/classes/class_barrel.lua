local PLAYER = {}

PLAYER.DisplayName			= "Barrel"

PLAYER.WalkSpeed 			= 180
PLAYER.RunSpeed				= 285
PLAYER.MaxHealth			= 1

function PLAYER:HUDPaint()
	if ( GAMEMODE:GetState() == STATE_PLAYING ) then
		draw.DrawText( "Destroy the humans!", "SB_TextMed", 16, 16, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		for _, pl in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
			local pos = pl:LocalToWorld( pl:OBBCenter() )
			local dpos = pos:ToScreen()

			draw.DrawText( pl:Health() .."%", "SB_TextBSmall", dpos.x, dpos.y - 16, HSVToColor( ( pl:Health() / 100 ) * 120, 1, 1 ), TEXT_ALIGN_CENTER )
		end

		draw.DrawText( "M1 to Explode. M2 to Taunt.", "SB_TextMed", W / 2, H - 42, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
end

function PLAYER:CalcView( pl, origin, angles, fov )
	local view = {}
	view.origin = GAMEMODE:SetThirdPerson( pl, origin, angles )
	view.angles = angles
	view.fov = fov

	return view
end

function PLAYER:ShouldDrawLocalPlayer()
	return true
end

function PLAYER:OnSpawn( pl )
	pl:SetModel( "models/props_c17/oildrum001_explosive.mdl" )

	pl:SetWalkSpeed( self.WalkSpeed )
	pl:SetRunSpeed( self.RunSpeed )
	pl:SetMaxHealth( self.MaxHealth )
	pl:SetHealth( pl:GetMaxHealth() )

	pl.CanExplode = CurTime() + 2
	pl.CanTaunt = CurTime() + 1
	pl.IsExploding = false

	--[[local plmin, plmax = pl:OBBMins(), pl:OBBMaxs()
	pl:SetHull( plmin, plmax )
	pl:SetHullDuck( plmin, plmax )]]
end

function PLAYER:OnKeyPress( pl, key )
	if ( key == IN_ATTACK ) && ( pl.CanExplode <= CurTime() ) then
		pl.IsExploding = true

		timer.Simple( 0.5, function() if IsValid( pl ) && pl:GonnaExplode() then pl:EmitSound( "Grenade.Blip" ) end end )
		timer.Simple( 1.0, function() if IsValid( pl ) && pl:GonnaExplode() then pl:EmitSound( "Grenade.Blip" ) end end )
		timer.Simple( 1.5, function() if IsValid( pl ) && pl:GonnaExplode() then pl:EmitSound( "Weapon_CombineGuard.Special1" ) end end )
		timer.Simple( 2.5, function() if IsValid( pl ) && pl:GonnaExplode() then pl:KillSilent() pl:SourceExplode( 150 ) end end )
		pl.CanExplode = CurTime() + 3
	elseif ( key == IN_ATTACK2 ) && ( pl.CanTaunt <= CurTime() ) then
		pl:EmitSound( table.Random( GAMEMODE.TAUNTS ), 100, math.random( 150, 175 ) )
		pl.CanTaunt = CurTime() + 1.5
	end
end

function PLAYER:CanSuicide( pl )
	return false
end

function PLAYER:OnPlayerDeath( pl, attacker )
	if ( pl ~= attacker ) then
		pl:SourceExplode( 100 )
	end
end

function PLAYER:OnLoadout( pl ) end

player_manager.RegisterClass( "class_barrel", PLAYER, "class_default" )