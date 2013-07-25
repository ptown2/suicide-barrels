function GM:AddResources()
	--resource.AddFile()
end

function GM:AddNetworkStrings()
	--util.AddNetworkString( "" )
end

function GM:SetupSpawns()
	team.SetSpawnPoint( TEAM_HUMAN, { "info_player_start", "info_player_terrorist", "info_player_rebel", "info_player_deathmatch" } )
	team.SetSpawnPoint( TEAM_BARREL, { "info_player_start", "info_player_counterterrorist", "info_player_combine" } )
end

function GM:SetupHuman( pl )
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

	pl:SetWalkSpeed( 200 )
	pl:SetRunSpeed( 260 )
	pl:Give( "weapon_sb_pistol" )
end

function GM:SetupBarrel( pl )
	pl:SetModel( "models/props_c17/oildrum001_explosive.mdl" )

	pl:SetWalkSpeed( 150 )
	pl:SetRunSpeed( 250 )

	pl:SetMaxHealth( 1 )
	pl:SetHealth( pl:GetMaxHealth() )

	pl.CanExplode = CurTime() + 2
	pl.CanTaunt = CurTime() + 1
end