function util.ChatToPlayers( str )
	for _, pl in pairs( player.GetAll() ) do
		pl:PrintMessage( HUD_PRINTTALK, str )
	end
end

function util.AndSeparate( list )
	local length = #list
	if length <= 0 then return "" end
	if length == 1 then return list[1] end
	if length == 2 then return list[1].." and "..list[2] end

	return table.concat( list, ", ", 1, length - 1 )..", and "..list[length]
end

function util.ToMinutesSeconds( seconds )
	local minutes = math.floor( seconds / 60 )
	seconds = seconds - minutes * 60

    return string.format( "%02d:%02d", minutes, math.floor( seconds ) )
end