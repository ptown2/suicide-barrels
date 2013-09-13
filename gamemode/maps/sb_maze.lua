-- TODO: Prevent users from jumping.

hook.Add( "PlayerBindPress", "MazePreventJump", function( pl, bind, on)
	if ( bind == "+jump" ) then return true end

	return false
end )