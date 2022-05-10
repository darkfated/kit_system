// FONTS

surface.CreateFont( 'CAS.MenuHeader', {
	font = 'Roboto',
	size = 36,
	weight = 800,
} )

surface.CreateFont( 'CAS.Item', {
	font = 'Roboto',
	size = 19,
	weight = 800,
} )

surface.CreateFont( 'CAS.ItemBig', {
	font = 'Roboto',
	size = 22,
	weight = 800,
} )

surface.CreateFont( 'CAS.InfoPanelMain', {
	font = 'Roboto',
	size = 24,
	weight = 800,
} )

surface.CreateFont( 'CAS.InfoPanel', {
	font = 'Roboto',
	size = 20,
	weight = 800,
} )

// MAIN
local WhiteColor = Color(255,255,255)
local GreyColor = Color(221,221,221)
local DarkColor = Color(45,45,45)
local color_menu_header = Color(102,102,102)
local color_menu_background = Color(68,68,73)
local color_background_main = Color(182,182,182)
local color_item_panel = Color(83,83,83)
local color_iteminfo_panel = Color(223,223,223)
local color_iteminfo = {
	Color(72,161,64), -- Weapons
	Color(95,137,214), -- Info
}
local color_btn_create = Color(216,113,66)
local color_btn_cmds_edit = Color(169,87,224)
local color_btn_apply_sett = Color(61,194,83)
local color_btn_delete_kit = Color(241,74,74)
local color_rank_selected = Color(87,126,172)
local color_rank_unselected = Color(39,113,197)
local sp_vbar = Color(94,94,94)
local sp_vbar_btn = Color(69,150,123)
local color_cmd = Color(216,79,79)
local color_btn_add_cmd = Color(41,40,48)

local function menuClick( snd )
	surface.PlaySound( snd or 'UI/buttonclickrelease.wav' )
end

local function scrollPanel( self )
	local VBar = self:GetVBar()
	VBar:SetWide( 10 )
	VBar:SetHideButtons( true )
	VBar.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, sp_vbar )
	end
	VBar.btnGrip.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, sp_vbar_btn )
	end
end

local function menuCreate( title )
	if ( IsValid( CAS.Menu ) ) then
		CAS.Menu:Remove()
	end

	CAS.Menu = vgui.Create( 'DFrame' )
	CAS.Menu:SetSize( ScrW(), ScrH() )
	CAS.Menu:Center()
	CAS.Menu:MakePopup()
	CAS.Menu:SetDraggable( false )
	CAS.Menu:SetTitle( '' )
	CAS.Menu:ShowCloseButton( false )
	CAS.Menu:DockPadding( 8, 68, 8, 8 )
	CAS.Menu.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_menu_background )
	end
	CAS.Menu.notify = ''

	local menu_header = vgui.Create( 'DPanel', CAS.Menu )
	menu_header:SetSize( CAS.Menu:GetWide(), 60 )
	menu_header.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, 60, color_menu_header )

		draw.SimpleText( title, 'CAS.MenuHeader', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
	end

	local menu_header_close = vgui.Create( 'DButton', menu_header )
	menu_header_close:Dock( RIGHT )
	menu_header_close:SetText( '' )
	menu_header_close.Paint = function( self, w, h )
		draw.SimpleText( 'X', 'CAS.MenuHeader', w * 0.5, h * 0.5, self:IsHovered() and GreyColor or WhiteColor, 1, 1 )
	end
	menu_header_close.DoClick = function()
		menuClick()
	
		CAS.Menu:Remove()
	end
end

local function createItemInfoPanel( self, item )
	// Weapons
	local panel_weapons = vgui.Create( 'DPanel', self )
	panel_weapons:Dock( LEFT )
	panel_weapons:SetWide( self:GetWide() * 0.3 )
	panel_weapons.Paint = nil

	local weapons_list = vgui.Create( 'DScrollPanel', panel_weapons )
	weapons_list:Dock( FILL )
	weapons_list:DockMargin( 8, 68, 8, 8 )
	
	scrollPanel( weapons_list )

	for z, weapon in pairs( item.weapon ) do
		local wpn_btn = vgui.Create( 'DButton', weapons_list )
		wpn_btn:Dock( TOP )
		wpn_btn:SetTall( 50 )
		wpn_btn:DockMargin( 4, 4, 4, 4 )

		for k, wep in pairs( list.Get( 'Weapon' ) ) do
			if ( wep.ClassName == weapon.class ) then
				wpn_btn:SetText( wep.PrintName )
			end
		end

		wpn_btn:SetFont( 'CAS.InfoPanel' )
		wpn_btn.DoClick = function()
			menuClick()
		end
		wpn_btn.Paint = function( self, w, h )
			draw.RoundedBox( 16, 0, 0, w, h, WhiteColor )
		end
	end

	// Info
	local panel_info = vgui.Create( 'DPanel', self )
	panel_info:Dock( LEFT )
	panel_info:DockMargin( 8, 0, 0,0 )
	panel_info:DockPadding( 0, 60, 0, 0 )
	panel_info:SetWide( self:GetWide() * 0.32 )
	panel_info.Paint = nil

	local function addText( txt )
		local info_text = vgui.Create( 'DPanel', panel_info )
		info_text:Dock( TOP )
		info_text:SetTall( 50 )
		info_text:DockMargin( 8, 8, 8, 8 )
		info_text.Paint = function( self, w, h )
			draw.SimpleText( txt, 'CAS.InfoPanel', w * 0.5, h * 0.5, DarkColor, 1, 1 )
		end
	end

	if ( item.health != 0 ) then
		addText( 'Health: ' .. item.health )
	end

	if ( item.armor != 0 ) then
		addText( 'Armor: ' .. item.armor )
	end

	if ( table.Count( item.rank_access ) != 0 ) then
		addText( 'Need a ' .. table.concat( item.rank_access, ' / ' ) )
	end

	if ( item.money != 0 ) then
		addText( 'The purchase is temporarily valid' )
	end

	if ( #panel_info:GetChildren() == 0 ) then
		addText( 'There are no additional parameters!' )
	end
end

local function OpenMen()
	menuCreate( 'CAS - Kit System' )

	local left_panel = vgui.Create( 'DPanel', CAS.Menu )
	left_panel:Dock( LEFT )
	left_panel:DockPadding( 0, 0, 0, 68 )
	left_panel:SetWide( CAS.Menu:GetWide() * 0.315 - 16 )
	left_panel.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, h - 60, w, 60, CAS.Menu.notify != '' and GreyColor or color_background_main )

		draw.SimpleText( CAS.Menu.notify, 'CAS.InfoPanelMain', w * 0.5, h - 30, DarkColor, 1, 1 )
	end

	local scroll_items_panel = vgui.Create( 'DPanel', left_panel )
	scroll_items_panel:Dock( FILL )
	scroll_items_panel:DockPadding( 8, 8, 8, 8 )
	scroll_items_panel.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_background_main )
	end

	local scroll_items = vgui.Create( 'DScrollPanel', scroll_items_panel )
	scroll_items:Dock( FILL )

	scrollPanel( scroll_items )

	local main_panel = vgui.Create( 'DPanel', CAS.Menu )
	main_panel:Dock( FILL )
	main_panel:DockMargin( 8, 0, 0, 0 )
	main_panel:DockPadding( 8, 68, 8, 8 )
	main_panel.Paint = function( self, w, h )
		if ( CAS.Menu.active == nil ) then
			draw.SimpleText( 'Choose a item', 'CAS.InfoPanelMain', w * 0.5, h * 0.5, WhiteColor, 1, 1 )

			return
		end

		draw.RoundedBox( 8, 0, 8, w, h - 8, color_background_main )
		draw.RoundedBox( 8, 0, 0, w, 60, color_item_panel )
		draw.RoundedBox( 0, 0, 52, w, 8, color_item_panel )
		draw.SimpleText( CAS.Menu.active.name, 'CAS.InfoPanelMain', w * 0.5, 30, WhiteColor, 1, 1 )

		draw.RoundedBox( 8, 8, 68, w * 0.3, h - 76, color_iteminfo_panel )
		draw.RoundedBox( 8, 8, 68, w * 0.3, 60, color_iteminfo[ 1 ] )
		draw.SimpleText( 'Weapons', 'CAS.InfoPanelMain', w * 0.15 + 8, 98, WhiteColor, 1, 1 )

		draw.RoundedBox( 8, w * 0.3 + 16, 68, w * 0.32, h - 76, color_iteminfo_panel )
		draw.RoundedBox( 8, w * 0.3 + 16, 68, w * 0.32, 60, color_iteminfo[ 2 ] )
		draw.SimpleText( 'Information', 'CAS.InfoPanelMain', w * 0.3 + w * 0.16 + 16, 98, WhiteColor, 1, 1 )
	end

	local function activeCreatePanel( self, item )
		if ( self:IsHovered() and CAS.Menu.active != item ) then
			menuClick( 'buttons/lightswitch2.wav' )
	
			main_panel:Clear()
	
			CAS.Menu.active = item
	
			createItemInfoPanel( main_panel, item )
		end
	end

	for num, item in pairs( CAS.List ) do
		local item_panel = vgui.Create( 'DPanel', scroll_items )
		item_panel:Dock( TOP )
		item_panel:DockMargin( 8, 8, 8, 0 )
		item_panel:SetTall( 56 + 40 )
		item_panel.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 8, w, h - 16, color_item_panel )

			draw.SimpleText( item.name, LocalPlayer():GetNWInt( 'CAS_ID' ) == num and 'CAS.ItemBig' or 'CAS.Item', w * 0.5 - 75, h * 0.5, WhiteColor, 1, 1 )

			activeCreatePanel( self, item )
		end

		local item_btn = vgui.Create( 'DButton', item_panel )
		item_btn:Dock( RIGHT )
		item_btn:SetWide( 150 )
		item_btn:SetText( '' )
		item_btn.DoClick = function()
			menuClick()

			net.Start( 'CAS-CALL' )
				net.WriteUInt( num, 8 )
			net.SendToServer()
		end
		item_btn.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 0, w, h, DarkColor )

			draw.SimpleText( LocalPlayer():GetNWInt( 'CAS_ID' ) == num and 'Used' or ( item.money == 0 and 'FREE' or DarkRP.formatMoney( item.money ) ), 'CAS.Item', w * 0.5, h * 0.5, GreyColor, 1, 1 )

			activeCreatePanel( self, item )
		end
	end

	if ( LocalPlayer():IsSuperAdmin() ) then
		local edit_btn = vgui.Create( 'DButton', CAS.Menu )
		edit_btn:SetPos( 10, 10 )
		edit_btn:SetSize( 80, 40 )
		edit_btn:SetText( 'Edit' )
		edit_btn:SetFont( 'CAS.MenuHeader' )
		edit_btn.Paint = function( self, w, h )
			draw.RoundedBox( 16, 0, 0, w, h, GreyColor )
		end
		edit_btn.DoClick = function()
			menuClick()

			RunConsoleCommand( 'cas_menu_edit' )
		end
	end
end

concommand.Add( 'cas_menu', OpenMen )

// EDIT mode
local function createKitSettings( pan, kit_num, func_rebuild )
	pan:Clear()

	local function createTitle( txt ) 
		local title = vgui.Create( 'DPanel', pan )
		title:Dock( TOP )
		title:DockMargin( 8, 8, 8, 8 )
		title:SetTall( 40 )
		title.Paint = function( self, w, h )
			draw.SimpleText( txt, 'CAS.InfoPanelMain', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end
	end

	createTitle( 'Name' )

	local kit_name = vgui.Create( 'DTextEntry', pan )
	kit_name:Dock( TOP )
	kit_name:DockMargin( 8, 0, 8, 0 )
	kit_name:SetTall( 30 )
	kit_name:SetFont( 'CAS.Item' )

	createTitle( 'Health (0 = standard)' )

	local kit_health = vgui.Create( 'DTextEntry', pan )
	kit_health:Dock( TOP )
	kit_health:DockMargin( 8, 0, 8, 0 )
	kit_health:SetTall( 30 )
	kit_health:SetFont( 'CAS.Item' )

	createTitle( 'Armor (0 = standard)' )

	local kit_armor = vgui.Create( 'DTextEntry', pan )
	kit_armor:Dock( TOP )
	kit_armor:DockMargin( 8, 0, 8, 0 )
	kit_armor:SetTall( 30 )
	kit_armor:SetFont( 'CAS.Item' )

	createTitle( 'Cost (0 = free)' )

	local kit_money = vgui.Create( 'DTextEntry', pan )
	kit_money:Dock( TOP )
	kit_money:DockMargin( 8, 0, 8, 0 )
	kit_money:SetTall( 30 )
	kit_money:SetFont( 'CAS.Item' )

	createTitle( 'Individual access to the kit' )
	
	local ranks_panel = vgui.Create( 'DPanel', pan )
	ranks_panel:Dock( TOP )
	ranks_panel:DockMargin( 8, 0, 8, 0 )
	ranks_panel:DockPadding( 6, 6, 6, 6 )
	ranks_panel:SetTall( 120 )
	ranks_panel.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_background_main )
	end

	local ranks_list = vgui.Create( 'DScrollPanel', ranks_panel )
	ranks_list:Dock( FILL )

	scrollPanel( ranks_list )

	for rank, rank_info in pairs( CAMI.GetUsergroups() ) do
		if ( rank == 'user' ) then
			continue
		end

		local pan = vgui.Create( 'DButton', ranks_list )
		pan:Dock( TOP )
		pan:DockMargin( 6, 0, 6, 0 )
		pan:SetText( '' )
		pan:SetTall( 30 )
		pan:SetSelectable( true )
		pan.id = rank
		pan.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 1, w, h - 2, self:IsSelected() and color_rank_unselected or color_rank_selected )

			draw.SimpleText( pan.id, 'CAS.Item', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end
		pan.DoClick = function()
			if ( pan:IsSelected() ) then
				pan:SetSelected( false )
			else
				pan:SetSelected( true )
			end
		end
		
		for m, n_rank in pairs( CAS.List[ kit_num ].rank_access ) do
			if ( rank == n_rank ) then
				pan:SetSelected( true )
			end
		end
	end

	createTitle( 'Weapon' )

	local weps_panel = vgui.Create( 'DPanel', pan )
	weps_panel:Dock( TOP )
	weps_panel:DockMargin( 8, 0, 8, 0 )
	weps_panel:DockPadding( 6, 6, 6, 6 )
	weps_panel:SetTall( 260 )
	weps_panel.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_background_main )
	end

	local weps_list = vgui.Create( 'DScrollPanel', weps_panel )
	weps_list:Dock( FILL )

	scrollPanel( weps_list )

	for x, wep in pairs( list.Get( 'Weapon' ) ) do
		if ( !wep.Spawnable ) then
			continue
		end

		local pan = vgui.Create( 'DButton', weps_list )
		pan:Dock( TOP )
		pan:DockMargin( 6, 0, 6, 0 )
		pan:SetText( '' )
		pan:SetTall( 30 )
		pan:SetSelectable( true )
		pan.id = wep
		pan.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 1, w, h - 2, self:IsSelected() and color_rank_unselected or color_rank_selected )

			draw.SimpleText( pan.id.PrintName, 'CAS.Item', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end
		pan.DoClick = function()
			if ( pan:IsSelected() ) then
				pan:SetSelected( false )
			else
				Derma_StringRequest( '', 'Select the number of ammo', 100, function( i )
					pan:SetSelected( true )
					pan.ammo = i
				end )
			end
		end

		for m, n_wep in pairs( CAS.List[ kit_num ].weapon ) do
			if ( pan.id.ClassName == n_wep.class ) then
				pan:SetSelected( true )
			end
		end
	end

	local BOTTOM_PANEL = vgui.Create( 'DPanel', pan )
	BOTTOM_PANEL:Dock( TOP )
	BOTTOM_PANEL:DockMargin( 8, 8, 8, 0 )
	BOTTOM_PANEL:SetTall( 60 )
	BOTTOM_PANEL.Paint = nil

	local SAVE_BTN = vgui.Create( 'DButton', BOTTOM_PANEL )
	SAVE_BTN:Dock( FILL )
	SAVE_BTN:SetText( '' )
	SAVE_BTN.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_btn_apply_sett )

		draw.SimpleText( 'SAVE', 'CAS.InfoPanelMain', w * 0.5, h * 0.5, self:IsHovered() and GreyColor or WhiteColor, 1, 1 )
	end
	SAVE_BTN.DoClick = function()
		menuClick()

		local tabl_ranks = {}

		for num_rank, btn_rank in pairs( ranks_list:GetSelectedChildren() ) do
			table.insert( tabl_ranks, btn_rank.id )
		end

		local tabl_weps = {}

		for num_wep, btn_wep in pairs( weps_list:GetSelectedChildren() ) do
			table.insert( tabl_weps, { class = btn_wep.id.ClassName, ammo = btn_wep.ammo } )
		end

		local kit_tabl = {
			name = kit_name:GetText(),
			health = tonumber( kit_health:GetText() ),
			armor = tonumber( kit_armor:GetText() ),
			money = tonumber( kit_money:GetText() ),
			rank_access = tabl_ranks,
			weapon = tabl_weps
		}

		net.Start( 'CAS-UPDATE-SERVER' )
			net.WriteUInt( kit_num, 8 )
			net.WriteTable( kit_tabl )
		net.SendToServer()

		timer.Simple( 1, function()
			if ( IsValid( CAS.Menu ) ) then
				func_rebuild()
			end
		end )
	end

	local DELETE_BTN = vgui.Create( 'DButton', BOTTOM_PANEL )
	DELETE_BTN:Dock( LEFT )
	DELETE_BTN:SetWide( pan:GetWide() * 0.5 )
	DELETE_BTN:SetText( '' )
	DELETE_BTN.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_btn_delete_kit )

		draw.SimpleText( 'DELETE', 'CAS.InfoPanelMain', w * 0.5, h * 0.5, self:IsHovered() and GreyColor or WhiteColor, 1, 1 )
	end
	DELETE_BTN.DoClick = function()
		menuClick()

		net.Start( 'CAS-UPDATE-REMOVE-KIT' )
			net.WriteUInt( kit_num, 8 )
		net.SendToServer()

		timer.Simple( 1, function()
			func_rebuild()

			pan:Clear()
		end )
	end

	local item = CAS.List[ kit_num ]

	kit_name:SetText( item.name )
	kit_health:SetText( item.health )
	kit_armor:SetText( item.armor )
	kit_money:SetText( item.money )
end

local function CreateCmdsEdit( pan )
	pan:Clear()

	local function createTitle( txt ) 
		local title = vgui.Create( 'DPanel', pan )
		title:Dock( TOP )
		title:DockMargin( 8, 8, 8, 8 )
		title:SetTall( 40 )
		title.Paint = function( self, w, h )
			draw.SimpleText( txt, 'CAS.InfoPanelMain', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end
	end

	createTitle( 'List of chat commands' )

	local cmds_panel = vgui.Create( 'DPanel', pan )
	cmds_panel:Dock( TOP )
	cmds_panel:DockMargin( 8, 0, 8, 0 )
	cmds_panel:DockPadding( 6, 6, 6, 6 )
	cmds_panel:SetTall( 260 )
	cmds_panel.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_background_main )
	end

	local cmds_list = vgui.Create( 'DScrollPanel', cmds_panel )
	cmds_list:Dock( FILL )

	scrollPanel( cmds_list )

	local function saveCmdsCAS()
		net.Start( 'CAS-UPDATE-SERVER-CMDS' )
			net.WriteTable( CAS.Commands )
		net.SendToServer()
	end

	local function createPanCmd( cmd, num_cmd )
		local pan = vgui.Create( 'DPanel', cmds_list )
		pan:Dock( TOP )
		pan:DockMargin( 6, 6, 6, 6 )
		pan:SetTall( 30 )
		pan.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 1, w, h - 2, color_cmd )

			draw.SimpleText( cmd, 'CAS.Item', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end
		pan.cmd = cmd

		local pan_btn = vgui.Create( 'DButton', pan )
		pan_btn:Dock( RIGHT )
		pan_btn:SetWide( 80 )
		pan_btn:SetText( '' )
		pan_btn.Paint = function( self, w, h )
			draw.SimpleText( 'DELETE', 'CAS.Item', w * 0.5, h * 0.5, self:IsHovered() and GreyColor or WhiteColor, 1, 1 )
		end
		pan_btn.DoClick = function()
			pan:Remove()

			table.remove( CAS.Commands, num_cmd )

			saveCmdsCAS()
		end
	end

	for k, cmd in pairs( CAS.Commands ) do
		createPanCmd( cmd )
	end

	local btn_add = vgui.Create( 'DButton', pan )
	btn_add:Dock( TOP )
	btn_add:DockMargin( 8, 8, 8, 0 )
	btn_add:SetTall( 60 )
	btn_add:SetText( '' )
	btn_add.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_btn_add_cmd )

		draw.SimpleText( 'Add a command', 'CAS.InfoPanelMain', w * 0.5, h * 0.5, self:IsHovered() and GreyColor or WhiteColor, 1, 1 )
	end
	btn_add.DoClick = function()
		menuClick()

		Derma_StringRequest( '', 'Write the desired command for the chat', '', function( i )
			createPanCmd( i )

			table.insert( CAS.Commands, i )

			saveCmdsCAS()
		end )
	end
end

local function OpenEditMen()
	menuCreate( 'CAS - Edit Mode' )

	local LeftPanel = vgui.Create( 'DPanel', CAS.Menu )
	LeftPanel:Dock( LEFT )
	LeftPanel:DockPadding( 0, 0, 0, 68 )
	LeftPanel:SetWide( CAS.Menu:GetWide() * 0.315 - 16 )
	LeftPanel.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, h - 60, w, 60, CAS.Menu.notify != '' and GreyColor or color_background_main )

		draw.SimpleText( CAS.Menu.notify, 'CAS.InfoPanelMain', w * 0.5, h - 30, DarkColor, 1, 1 )
	end

	local MAIN_PANEL = vgui.Create( 'DPanel', CAS.Menu )
	MAIN_PANEL:Dock( FILL )
	MAIN_PANEL:DockMargin( 8, 0, 0, 0 )
	MAIN_PANEL.Paint = nil

	local main_sp = vgui.Create( 'DScrollPanel', MAIN_PANEL )
	main_sp:Dock( FILL )
	main_sp.Paint = nil

	scrollPanel( main_sp )

	local kits_list_panel = vgui.Create( 'DPanel', LeftPanel )
	kits_list_panel:Dock( FILL )
	kits_list_panel:DockMargin( 0, 8, 0, 0 )
	kits_list_panel:DockPadding( 8, 8, 8, 8 )
	kits_list_panel.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_background_main )
	end

	local kits_list = vgui.Create( 'DScrollPanel', kits_list_panel )
	kits_list:Dock( FILL )

	scrollPanel( kits_list )

	local function CreateKitList()
		if ( !IsValid( CAS.Menu ) ) then
			return
		end

		kits_list:Clear()

		for num, item in pairs( CAS.List ) do
			local item_panel = vgui.Create( 'DPanel', kits_list )
			item_panel:Dock( TOP )
			item_panel:DockMargin( 8, 8, 8, 0 )
			item_panel:SetTall( 56 + 40 )
			item_panel.Paint = function( self, w, h )
				draw.RoundedBox( 8, 0, 0, w, h, color_item_panel )
	
				draw.SimpleText( item.name, 'CAS.Item', w * 0.5 + 75, h * 0.5, WhiteColor, 1, 1 )
			end
	
			local item_btn = vgui.Create( 'DButton', item_panel )
			item_btn:Dock( LEFT )
			item_btn:SetWide( 150 )
			item_btn:SetText( '' )
			item_btn.DoClick = function()
				menuClick()
			end
			item_btn.Paint = function( self, w, h )
				draw.RoundedBox( 8, 0, 0, w, h, DarkColor )
	
				draw.SimpleText( 'settings', 'CAS.Item', w * 0.5, h * 0.5, GreyColor, 1, 1 )
			end
			item_btn.DoClick = function()
				menuClick()
	
				createKitSettings( main_sp, num, function()
					CreateKitList()
				end )
			end
		end
	end

	CreateKitList()

	local create_kit_btn = vgui.Create( 'DButton', LeftPanel )
	create_kit_btn:Dock( TOP )
	create_kit_btn:SetTall( 60 )
	create_kit_btn:SetText( '' )
	create_kit_btn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_btn_create )

		draw.SimpleText( 'Create kit', 'CAS.InfoPanelMain', w * 0.5, h * 0.5, self:IsHovered() and GreyColor or WhiteColor, 1, 1 )
	end
	create_kit_btn.DoClick = function()
		menuClick()

		local kit_tabl = {
			name = 'New kit',
			health = 0,
			armor = 0,
			money = 0,
			rank_access = {},
			weapon = {}
		}

		net.Start( 'CAS-UPDATE-KITS-SERVER' )
			net.WriteUInt( table.Count( CAS.List ) + 1, 8 )
			net.WriteTable( kit_tabl )
		net.SendToServer()
		
		timer.Simple( 1, function()
			CreateKitList()
		end )
	end

	local set_cmds_btn = vgui.Create( 'DButton', LeftPanel )
	set_cmds_btn:Dock( TOP )
	set_cmds_btn:DockMargin( 0, 8, 0, 0 )
	set_cmds_btn:SetTall( 60 )
	set_cmds_btn:SetText( '' )
	set_cmds_btn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_btn_cmds_edit )

		draw.SimpleText( 'Edit chat commands', 'CAS.InfoPanelMain', w * 0.5, h * 0.5, self:IsHovered() and GreyColor or WhiteColor, 1, 1 )
	end
	set_cmds_btn.DoClick = function()
		menuClick()

		CreateCmdsEdit( main_sp )
	end

	local return_btn = vgui.Create( 'DButton', CAS.Menu )
	return_btn:SetPos( 10, 10 )
	return_btn:SetSize( 114, 40 )
	return_btn:SetText( 'Return' )
	return_btn:SetFont( 'CAS.MenuHeader' )
	return_btn.Paint = function( self, w, h )
		draw.RoundedBox( 16, 0, 0, w, h, GreyColor )
	end
	return_btn.DoClick = function()
		menuClick()

		RunConsoleCommand( 'cas_menu' )
	end
end

concommand.Add( 'cas_menu_edit', OpenEditMen )

// Net requests

net.Receive( 'CAS-TEXT', function()
	local txt = net.ReadString()

	CAS.Menu.notify = txt

	timer.Simple( 1.5, function()
		if ( IsValid( CAS.Menu ) ) then
			if ( CAS.Menu.notify == txt ) then
				CAS.Menu.notify = ''
			end
		end
	end )
end )

net.Receive( 'CAS-UPDATE', function()
	local tabl = net.ReadTable()

	CAS.List = tabl.kits
	CAS.Commands = tabl.commands
end )
