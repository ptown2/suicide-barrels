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

module( "GScoreboard", package.seeall )
ScoreboardPanel = nil
IP = "192.168.0.44:27015"
JoinTime = RealTime()

net.Receive("GSendIP", function(len)
	IP = net.ReadString()
end )

function CreateScoreboard( )
	if(ScoreboardPanel != nil) then KillScoreboard( ) end
	ScoreboardPanel = vgui.Create( "DFrame" )
	ScoreboardPanel:SetPos( 0, 0 )
	ScoreboardPanel:SetSize( ScrW( ), ScrH( ) )
	ScoreboardPanel:ShowCloseButton( false )
	ScoreboardPanel:SetTitle( "" )
	ScoreboardPanel:SetDraggable( false )
	ScoreboardPanel:SetVisible( true )
	--ScoreboardPanel:MakePopup( )
	local Bots = player.GetBots()
	ScoreboardPanel.Paint = function()
		surface.SetDrawColor( Color( 10, 10, 10, 240 ) )
		surface.DrawRect( 0, 0, ScoreboardPanel:GetWide( ), ScoreboardPanel:GetTall( ) )

		DrawHostname()
		DrawTeam1Panel()
		DrawTeam2Panel()
		DrawConnectingPanel()
		//DrawConnectingPlayers(Bots)
	end
end

function DrawHostname()
	draw.SimpleText(GetHostName(), "Scoreboard_Hostname", ScoreboardPanel:GetWide( )/2, ScoreboardPanel:GetTall( ) * 0.04, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(#player.GetAll().."/"..GetConVarString("maxplayers").." Players", "Scoreboard_ServerInfo", ScoreboardPanel:GetWide( )/2, ScoreboardPanel:GetTall( ) * 0.09, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	local width, height = surface.GetTextSize( IP )
	draw.SimpleText(IP, "Scoreboard_ServerInfo", ScoreboardPanel:GetWide( ) * 0.01, ScoreboardPanel:GetTall( ) - ( height / 2 ), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	width, height = surface.GetTextSize( IP )

	local Rank = "User"
	if( LocalPlayer():IsSuperAdmin() ) then Rank = "Super Admin" elseif( LocalPlayer():IsAdmin() ) then Rank = "Admin" end
	draw.SimpleText("You're a "..Rank, "Scoreboard_ServerInfo", ScoreboardPanel:GetWide( ) * 0.99, ScoreboardPanel:GetTall( ) - height * 1.3, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	draw.SimpleText("Joined "..string.NiceTime(RealTime() - JoinTime).." ago", "Scoreboard_PlayTime", ScoreboardPanel:GetWide( ) * 0.99, ScoreboardPanel:GetTall( ) - height/2, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
end

function DrawConnectingPlayers(Bots)
	surface.SetDrawColor( Color( 255, 255, 255, 130 ) )
	for Number, Ent in pairs(Bots) do
		local xID = math.ceil( Number / 3 )

		local yOffs = (Number-xID*3) * (ScoreboardPanel:GetTall( ) * 0.04)
		local xOffs = xID * ScoreboardPanel:GetWide( ) * 0.12
		

		surface.DrawRect( xOffs + ScoreboardPanel:GetWide( ) * 0.18, ScoreboardPanel:GetTall( ) * 0.94 + yOffs, ScoreboardPanel:GetWide( ) * 0.1, ScoreboardPanel:GetTall( ) * 0.03 )
		draw.SimpleText( Ent:Nick(), "Scoreboard_InfoText", xOffs + ScoreboardPanel:GetWide( ) * 0.27,  ScoreboardPanel:GetTall( ) * 0.942 + yOffs, Color( 255, 0, 0 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
	end
end

function DrawConnectingPanel()
	surface.SetDrawColor( Color( 253, 211, 59, 50 ) )
	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.1, ScoreboardPanel:GetTall( ) * 0.85, ScoreboardPanel:GetWide( ) * 0.8, ScoreboardPanel:GetTall( ) * 0.01 )
	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.1, ScoreboardPanel:GetTall( ) * 0.86, ScoreboardPanel:GetWide( ) * 0.2, ScoreboardPanel:GetTall( ) * 0.03 )
	draw.SimpleText( "Connecting", "Scoreboard_InfoText", ScoreboardPanel:GetWide( ) * 0.16, ScoreboardPanel:GetTall( )* 0.857, Color( 222, 216, 209 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
end

function DrawTeam1Panel()
	surface.SetDrawColor( Color( 106, 133, 153, 200 ) )
	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.1, ScoreboardPanel:GetTall( ) * 0.15, ScoreboardPanel:GetWide( ) * 0.005, ScoreboardPanel:GetTall( ) * 0.65 )
	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.105, ScoreboardPanel:GetTall( ) * 0.15, ScoreboardPanel:GetWide( ) * 0.35, ScoreboardPanel:GetTall( ) * 0.009 )

	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.1, ScoreboardPanel:GetTall( ) * 0.12, ScoreboardPanel:GetWide( ) * 0.2, ScoreboardPanel:GetTall( ) * 0.03 )
	draw.SimpleText( "Insert Team 1 Name Here", "Scoreboard_InfoText", ScoreboardPanel:GetWide( ) * 0.11, ScoreboardPanel:GetTall( )* 0.123, Color( 222, 216, 209 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
end

function DrawTeam2Panel()
	surface.SetDrawColor( Color( 135, 167, 147, 200 ) )
	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.9, ScoreboardPanel:GetTall( ) * 0.15, ScoreboardPanel:GetWide( ) * 0.005, ScoreboardPanel:GetTall( ) * 0.65 )
	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.55, ScoreboardPanel:GetTall( ) * 0.15, ScoreboardPanel:GetWide( ) * 0.35, ScoreboardPanel:GetTall( ) * 0.009 )

	surface.DrawRect( ScoreboardPanel:GetWide( ) * 0.705, ScoreboardPanel:GetTall( ) * 0.12, ScoreboardPanel:GetWide( ) * 0.2, ScoreboardPanel:GetTall( ) * 0.03 )
	draw.SimpleText( "Insert Team 2 Name Here", "Scoreboard_InfoText", ScoreboardPanel:GetWide( ) * 0.895, ScoreboardPanel:GetTall( )* 0.123, Color( 222, 216, 209 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT )
end

function KillScoreboard( )
	if(ScoreboardPanel != nil) then
		ScoreboardPanel:SetVisible( false )
		ScoreboardPanel = nil
	end
end