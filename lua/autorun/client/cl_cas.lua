// FONTS

surface.CreateFont( 'CAS.Header', {
	font = 'Roboto',
	size = 26,
	weight = 800,
} )

surface.CreateFont( 'CAS.Btn', {
	font = 'Roboto',
	size = 22,
	weight = 800,
} )

surface.CreateFont( 'CAS.Btn.Small', {
	font = 'Roboto',
	size = 18,
	weight = 800,
} )

surface.CreateFont( 'CAS.Info', {
	font = 'Roboto',
	size = 16,
	weight = 800,
} )

// MAIN

local WhiteColor = Color(255,255,255)
local color_black = Color(0,0,0)
local color_background = Color(68,68,73)
local color_header = Color(102,102,102)
local color_cat_donat = Color(255,119,119,210)
local color_cat_time = Color(101,142,255,210)
local color_cat_stand = Color(72,221,109,210)
local color_item_header = Color(55,55,55)
local color_btn = Color(245,245,245)
local color_split_panel = Color(225,235,255)
local color_title_panel = Color(0,0,0,130)
local color_panel_info = Color(0,0,0,100)
local color_vbar = Color(225,235,255)
local color_vbar_depr = Color(190,198,214)

local function spPaint( pan )
	local vbar = pan:GetVBar()
	vbar:SetWide( 14 )
	vbar:SetHideButtons( true )
	vbar.Paint = nil
	vbar.btnGrip.Paint = function( self, w, h )
		draw.RoundedBox( 4, 8, 0, w - 8, h, self.Depressed and color_vbar_depr or color_vbar )
	end
end

local function OpenMen()
	local menu = vgui.Create( 'DFrame' )
	menu:SetSize( math.min( ScrW() * 0.4, 400 ), ScrH() * 0.8 )
	menu:Center()
	menu:MakePopup()
	menu:SetTitle( 'CAS Equipment' )
	menu:ShowCloseButton( false )
	menu.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_background )
		draw.RoundedBox( 8, 0, 0, w, 24, color_header )
		draw.RoundedBox( 0, 0, 12, w, 12, color_header )
	end

	local close_button = vgui.Create( 'DButton', menu )
	close_button:SetSize( 12, 12 )
	close_button:SetPos( menu:GetWide() - 6 - close_button:GetWide(), 6 )
	close_button:SetText( '' )
	close_button.DoClick = function()
		menu:Close()
	end
	close_button.Paint = function( self, w, h )
		surface.SetDrawColor( WhiteColor )
		surface.DrawLine( 0, 0, w, h )
		surface.DrawLine( w, 0, 0, h )
	end

	local hor_scroll = vgui.Create( 'DScrollPanel', menu )
	hor_scroll:Dock( FILL )
	hor_scroll:DockMargin( 4, 4, 4, 4 )

	spPaint( hor_scroll )

	local cat_donat = vgui.Create( 'DCollapsibleCategory', hor_scroll )
	cat_donat:Dock( TOP )
	cat_donat:SetLabel( 'Privileges' )
	cat_donat.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_cat_donat )
	end

	local DermaList_donat = vgui.Create( 'DPanelList', cat_donat )

	cat_donat:SetContents( DermaList_donat )

	local cat_time = vgui.Create( 'DCollapsibleCategory', hor_scroll )
	cat_time:Dock( TOP )
	cat_time:SetLabel( 'For one session' )
	cat_time.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_cat_time )
	end

	local DermaList_time = vgui.Create( 'DPanelList', cat_time )

	cat_time:SetContents( DermaList_time )

	local cat_stand = vgui.Create( 'DCollapsibleCategory', hor_scroll )
	cat_stand:Dock( TOP )
	cat_stand:SetLabel( 'Standart' )
	cat_stand.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, color_cat_stand )
	end

	local DermaList_stand = vgui.Create( 'DPanelList', cat_stand )

	cat_stand:SetContents( DermaList_stand )

	for numItem, item in pairs( CAS.List ) do
		local pan = vgui.Create( 'DPanel' )

		pan:Dock( TOP )
		pan:SetTall( 226 )
		pan.Paint = nil

		local main = vgui.Create( 'DPanel', pan )
		main:Dock( FILL )
		main.Paint = nil

		local header = vgui.Create( 'DPanel', main )
		header:Dock( TOP )
		header:DockMargin( 8, 0, 8, 0 )
		header:SetTall( 60 )
		header.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, color_item_header )

			draw.SimpleText( item.name, 'CAS.Header', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end

		local main_pnl = vgui.Create( 'DPanel', main )
		main_pnl:Dock( LEFT )
		main_pnl:DockMargin( 8 + 4, 0, 8 + 4, 8 )
		main_pnl:SetWide( menu:GetWide() * 0.4 )
		main_pnl.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, -6, w, h + 6, color_panel_info )
		end

		local main_sp = vgui.Create( 'DScrollPanel', main_pnl )
		main_sp:Dock( FILL )
		main_sp:DockMargin( 4, 4, 4, 4 )

		spPaint( main_sp )

		local function createLabel( txt )
			local text = vgui.Create( 'DPanel', main_sp )
			text:Dock( TOP )
			text:SetTall( 18 )
			text:DockMargin( 0, 0, 0, 8 )
			text.Paint = function( self, w, h )
				draw.SimpleText( txt, 'CAS.Info', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
			end
		end

		if ( item.health ) then
			createLabel( 'Health: ' .. item.health )
		end

		if ( item.armor ) then
			createLabel( 'Armor: ' .. item.armor )
		end

		for m, wp in pairs( item.weapon ) do
			createLabel( wp )
		end

		local btn = vgui.Create( 'DButton', pan )
		btn:Dock( BOTTOM )
		btn:SetTall( 50 )
		btn:SetText( 'APPLY' )

		if ( item.money and LocalPlayer():GetNWBool( numItem ) != true ) then
			btn:SetText( 'Buy for ' .. DarkRP.formatMoney( item.money ) )
		elseif ( item.money != 0 and LocalPlayer():GetNWBool( numItem ) == true ) then
			btn:SetText( 'Select (purchased)' )
		end

		btn:SetFont( 'CAS.Btn' )
		btn:DockMargin( 8, 0, 8, 8 )
		btn.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			if ( item.money and LocalPlayer():GetNWBool( numItem ) != true ) then
				net.Start( 'cas_buy' )
					net.WriteFloat( numItem )
				net.SendToServer()

				btn:SetText( 'Select (purchased)' )

				return
			end

			net.Start( 'cas_call' )
				net.WriteFloat( numItem )
			net.SendToServer()

			menu:Close()
		end
		btn.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, color_btn )
		end

		if ( item.donat ) then
			DermaList_donat:AddItem( pan )
		elseif ( item.time ) then
			DermaList_time:AddItem( pan )
		else
			DermaList_stand:AddItem( pan )
		end
	end

	if ( CAS.DopList[ 1 ] != nil ) then
		local split_pnl = vgui.Create( 'DPanel' )
		split_pnl:SetTall( 8 )
		split_pnl.Paint = function( self, w, h )
			draw.RoundedBox( 6, 8, 0, w - 16, h, color_split_panel )
		end

		DermaList_time:AddItem( split_pnl )
	end

	for numItem, item_dop in pairs( CAS.DopList ) do
		local pan = vgui.Create( 'DPanel' )
		pan:SetTall( 70 )
		pan.Paint = nil

		local title = vgui.Create( 'DPanel', pan )
		title:Dock( FILL )
		title:DockMargin( 8, 8, 8, 8 )
		title.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, color_title_panel )

			draw.SimpleText( item_dop.name, 'CAS.Header', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end

		local btn_buy = vgui.Create( 'DButton', pan )
		btn_buy:Dock( RIGHT )
		btn_buy:DockMargin( 0, 4, 8, 4 )
		btn_buy:SetWide( 140 )
		btn_buy:SetFont( 'CAS.Btn.Small' )

		if ( LocalPlayer():GetNWBool( 'cas_dop_' .. numItem ) ) then
			btn_buy:SetText( 'Used (purchased)' )
		else
			btn_buy:SetText( 'Buy: ' .. DarkRP.formatMoney( item_dop.money ) )
		end

		btn_buy.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, WhiteColor )
		end

		btn_buy.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			if ( not LocalPlayer():GetNWBool( 'cas_dop_' .. numItem ) ) then
				net.Start( 'cas_buy' )
					net.WriteFloat( numItem )
					net.WriteBool( true )
				net.SendToServer()

				btn_buy:SetText( 'Used (purchased)' )
			end
		end

		DermaList_time:AddItem( pan )
	end
end

concommand.Add( 'cas_menu', OpenMen )

net.Receive( 'cas_text', function()
	local txt = net.ReadString()

	chat.AddText( Color(174,160,255), '[CAS] ', WhiteColor, txt )
	chat.PlaySound()
end )
