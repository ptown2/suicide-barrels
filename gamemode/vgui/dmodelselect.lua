local pPlayerModel

local function SwitchPlayerModel(self)
	surface.PlaySound( "buttons/button14.wav" )
	RunConsoleCommand( "cl_playermodel", self.m_ModelName )
	chat.AddText( Color( 0, 255, 0, 255), "You've changed your desired player model to " ..tostring(self.m_ModelName).. "." )

	pPlayerModel:Close()
end

function MakepPlayerModel()
	if pPlayerModel and pPlayerModel:Valid() then pPlayerModel:Remove() end

	local numcols = 8
	local wid = numcols * 68 + 24
	local hei = 400

	pPlayerModel = vgui.Create( "DFrame" )
	pPlayerModel:SetSkin( "Default" )
	pPlayerModel:SetTitle( "Player model selection" )
	pPlayerModel:SetSize( wid, hei )
	pPlayerModel:Center()
	pPlayerModel:SetDeleteOnClose( true )

	local list = vgui.Create( "DPanelList", pPlayerModel )
	list:StretchToParent( 8, 24, 8, 8 )
	list:EnableVerticalScrollbar()

	local grid = vgui.Create( "DGrid", pPlayerModel )
	grid:SetCols(numcols)
	grid:SetColWide( 68 )
	grid:SetRowHeight( 68 )
	
	for name, mdl in pairs( player_manager.AllValidModels() ) do
		local button = vgui.Create( "SpawnIcon", grid )
		button:SetPos( 0, 0 )
		button:SetModel( mdl )
		button.m_ModelName = name
		button.OnMousePressed = SwitchPlayerModel
		grid:AddItem( button )
	end
	grid:SetSize( wid - 16, math.ceil( table.Count( player_manager.AllValidModels() ) / numcols) * grid:GetRowHeight() )

	list:AddItem( grid )

	pPlayerModel:SetSkin( "Default" )
	pPlayerModel:MakePopup()
end