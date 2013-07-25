/* --------------------------------------------------------------------------
	Suicide Barrels GM13 Edition
	Copyright (C) 2013  Robert Lind (ptown2) and David Marcec (ogniK)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------- */

module( "GNetwork", package.seeall )

function StartupNetwork( )
	GetWorldSpawn( ).GVars = { }
	-- Add network strings here
end

function GetWorldSpawn( )
	local WorldSpawn
	if SERVER then WorldSpawn = game.GetWorld( ) end
	if( WorldSpawn == nil ) then WorldSpawn = ents.FindByClass( "worldspawn" )[1] end
	return WorldSpawn
end

function GetGVar( Var, DefaultValue )
	local Worldspawn = GetWorldSpawn( )

	if( Worldspawn != nil ) then
		if( Worldspawn.GVars == nil ) then ErrorNoHalt( "You forgot to startup GNetwork!!!" ) return false end
		if( Worldspawn.GVars[Var] == nil ) then return DefaultValue end
		return Worldspawn.GVars[Var]
	end
	return DefaultValue
end

function SetGVar( Var, Value )
	local Worldspawn = GetWorldSpawn( )
	if( Worldspawn != nil ) then
		if( Worldspawn.GVars == nil ) then ErrorNoHalt( "You forgot to startup GNetwork!!!" ) return false end
		Worldspawn.GVars[Var] = Value
		return true
	end
	return false
end