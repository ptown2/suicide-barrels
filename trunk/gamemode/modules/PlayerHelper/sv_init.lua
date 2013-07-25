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

local meta = FindMetaTable( "Player" )
if not meta then Error( "Failed to find player meta table." ) end

function meta:SBExplode( Radius )
	local Boom = ents.Create( "env_explosion" )
	Boom:SetPos( self:GetPos() )
	Boom:Spawn( )
	Boom:SetKeyValue( "iMagnitude", tostring(Radius) )
	Boom:Fire( "Explode", 0, 0 )
	self:Kill( )
end