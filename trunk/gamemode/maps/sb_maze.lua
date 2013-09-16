-- TODO: Prevent users from jumping.

hook.Add("CreateMove", "NoJumping", function( cmd )
    if cmd:GetButtons() & ( IN_JUMP > 0 ) then
       cmd:SetButtons( cmd:GetButtons() - IN_JUMP )
    end
end )

/*
hook.Add( "PlayerBindPress", "MazePreventJump", function( pl, bind, on )
	if ( bind == "+jump" ) then return true end

	return false
end )
*/