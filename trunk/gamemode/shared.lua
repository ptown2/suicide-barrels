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

GM.Name		= "Suicide Barrels"
GM.Author	= "ogniK & ptown2"
GM.Email	= ""
GM.Website	= ""
GM.Revision	= 4

include( "sh_loading.lua" )

function GM:GetGameDescription()
	return self.Name
end

function GM:PrecacheResources()
end

function GM:LoadModules()
	--GLoad.LoadDirectory( "modules" )	-- Don't load every module...
end