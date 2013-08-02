local PLAYER = {}

PLAYER.DisplayName			= "Barrel"

PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 270
PLAYER.MaxHealth			= 1

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

	--[[local plmin, plmax = pl:OBBMins(), pl:OBBMaxs()
	pl:SetHull( plmin, plmax )
	pl:SetHullDuck( plmin, plmax )]]
end

function PLAYER:OnKeyPress( pl, key )
	if ( key == IN_ATTACK ) && ( pl.CanExplode <= CurTime() ) then
		timer.Simple( 0.5, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
		timer.Simple( 1.0, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
		timer.Simple( 1.5, function() if IsValid( pl ) && pl:Alive() then pl:EmitSound( "Weapon_CombineGuard.Special1" ) end end )
		timer.Simple( 2.5, function() if IsValid( pl ) && pl:Alive() then pl:SourceExplode( 128 ) end end )
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
		pl:SourceExplode( 96 )
	end
end

function PLAYER:HUDPaint() end
function PLAYER:OnLoadout( pl ) end

player_manager.RegisterClass( "class_barrel", PLAYER, "class_default" )