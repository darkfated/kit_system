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

surface.CreateFont( 'CAS.Info', {
	font = 'Roboto',
	size = 16,
	weight = 800,
} )

// MAIN

local WhiteColor = Color(255,255,255)
local color_black = Color(0,0,0)

local function spPaint( pan )
	local vbar = pan:GetVBar()
	vbar:SetWide( 14 )
	vbar:SetHideButtons( true )
	vbar.Paint = nil
	vbar.btnGrip.Paint = function( self, w, h )
		draw.RoundedBox( 4, 8, 8, w - 8, h - 16, self.Depressed and Color(190,198,214) or Color(225,235,255) )
	end
end

local function OpenMen()
	local menu = vgui.Create( 'DFrame' )
	menu:SetSize( math.min( ScrW() * 0.4, 400 ), ScrH() * 0.8 )
	menu:Center()
	menu:MakePopup()
	menu:SetTitle( 'Equipment' )
	menu:ShowCloseButton( false )
	menu.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color(45,45,45,220) )
		draw.RoundedBox( 0, 0, 0, w, 24, Color(99,99,99) )
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
		draw.RoundedBox( 4, 0, 0, w, h, Color(255,119,119,210) )
	end

	local DermaList_donat = vgui.Create( 'DPanelList', cat_donat )

	cat_donat:SetContents( DermaList_donat )

	local cat_time = vgui.Create( 'DCollapsibleCategory', hor_scroll )
	cat_time:Dock( TOP )
	cat_time:SetLabel( 'For one session' )
	cat_time.Paint = function( self, w, h )
		draw.RoundedBox( 4, 0, 0, w, h, Color(101,142,255,210) )
	end

	local DermaList_time = vgui.Create( 'DPanelList', cat_time )

	cat_time:SetContents( DermaList_time )

	local cat_stand = vgui.Create( 'DCollapsibleCategory', hor_scroll )
	cat_stand:Dock( TOP )
	cat_stand:SetLabel( 'Standart' )
	cat_stand.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color(72,221,109,210) )
	end

	local DermaList_stand = vgui.Create( 'DPanelList', cat_stand )

	cat_stand:SetContents( DermaList_stand )

	for k, v in pairs( CAS.List ) do
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
			draw.RoundedBox( 6, 0, 0, w, h, Color(55,55,55) )

			draw.SimpleText( v.name, 'CAS.Header', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end

		local pan_inf = vgui.Create( 'DScrollPanel', main )
		pan_inf:Dock( LEFT )
		pan_inf:DockMargin( 8 + 4, 0, 8 + 4, 8 )
		pan_inf:SetWide( menu:GetWide() * 0.4 )
		pan_inf.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, -6, w, h + 6, Color(0,0,0,100) )
		end

		spPaint( pan_inf )

		local function createLabel( txt )
			local text = vgui.Create( 'DPanel', pan_inf )
			text:Dock( TOP )
			text:SetTall( 18 )
			text:DockMargin( 0, 0, 0, 8 )
			text.Paint = function( self, w, h )
				draw.SimpleText( txt, 'CAS.Info', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
			end
		end

		if ( v.health != nil and v.health != 0 ) then
			createLabel( 'Health: ' .. v.health )
		end

		if ( v.armor != nil and v.armor != 0 ) then
			createLabel( 'Armor: ' .. v.armor )
		end

		for m, wp in pairs( v.weapon ) do
			createLabel( wp )
		end

		local btn = vgui.Create( 'DButton', pan )
		btn:Dock( BOTTOM )
		btn:SetTall( 50 )
		btn:SetText( 'APPLY' )

		if ( v.money != nil and LocalPlayer():GetNWBool( v.id ) != true ) then
			btn:SetText( 'Buy for ' .. DarkRP.formatMoney( v.money ) )
		elseif ( v.money != 0 and LocalPlayer():GetNWBool( v.id ) == true ) then
			btn:SetText( 'Select (purchased)' )
		end

		btn:SetFont( 'CAS.Btn' )
		btn:DockMargin( 8, 0, 8, 8 )
		btn.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			if ( v.money != nil and LocalPlayer():GetNWBool( v.id ) != true ) then
				net.Start( 'cas_buy' )
					net.WriteFloat( v.id )
					net.WriteFloat( v.money )
				net.SendToServer()

				menu:Close()

				return
			end

			net.Start( 'cas_call' )
				local wep_table = {}

				for b, n in pairs( v.weapon ) do
					table.insert( wep_table, n )
				end

				net.WriteTable( wep_table )
				net.WriteFloat( v.health )
				net.WriteFloat( v.armor )

				local rank_table = {}

				for h, j in pairs( v.rank ) do
					table.insert( rank_table, j )
				end

				net.WriteTable( rank_table )
				net.WriteFloat( v.id )
			net.SendToServer()

			menu:Close()
		end
		btn.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, Color(245,245,245) )
		end

		if ( v.donat ) then
			DermaList_donat:AddItem( pan )
		elseif ( v.time ) then
			DermaList_time:AddItem( pan )
		else
			DermaList_stand:AddItem( pan )
		end
	end

	if ( CAS.DopList[ 1 ] != nil ) then
		local split_pnl = vgui.Create( 'DPanel' )
		split_pnl:SetTall( 8 )
		split_pnl.Paint = function( self, w, h )
			draw.RoundedBox( 6, 8, 0, w - 16, h, Color(225,235,255) )
		end

		DermaList_time:AddItem( split_pnl )
	end

	for x, c in pairs( CAS.DopList ) do
		local pan = vgui.Create( 'DPanel' )
		pan:SetTall( 70 )
		pan.Paint = nil

		local title = vgui.Create( 'DPanel', pan )
		title:Dock( FILL )
		title:DockMargin( 8, 8, 8, 8 )
		title.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, Color(0,0,0,130) )

			draw.SimpleText( c.name, 'CAS.Header', w * 0.5, h * 0.5, WhiteColor, 1, 1 )
		end

		local btn_buy = vgui.Create( 'DButton', pan )
		btn_buy:Dock( RIGHT )
		btn_buy:DockMargin( 0, 4, 8, 4 )
		btn_buy:SetWide( 140 )

		if ( LocalPlayer():GetNWBool( 'cas_dop_' .. c.id ) ) then
			btn_buy:SetText( 'Used (purchased)' )
		else
			btn_buy:SetText( 'Buy: ' .. DarkRP.formatMoney( c.money ) )
		end

		btn_buy.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, WhiteColor )
		end

		btn_buy.DoClick = function()
			surface.PlaySound( 'UI/buttonclickrelease.wav' )

			net.Start( 'cas_buy' )
				net.WriteFloat( c.id )
				net.WriteFloat( c.money )
				net.WriteBool( true )
			net.SendToServer()

			menu:Close()
		end

		DermaList_time:AddItem( pan )
	end
end

concommand.Add( 'cas_menu', OpenMen )
