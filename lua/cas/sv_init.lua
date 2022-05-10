util.AddNetworkString( 'CAS-TEXT' )
util.AddNetworkString( 'CAS-CALL' )
util.AddNetworkString( 'CAS-UPDATE' )
util.AddNetworkString( 'CAS-UPDATE-SERVER' )
util.AddNetworkString( 'CAS-UPDATE-REMOVE-KIT' )
util.AddNetworkString( 'CAS-UPDATE-SERVER-CMDS' )

local function sendText( ply, txt )
	net.Start( 'CAS-TEXT' )
		net.WriteString( txt )
	net.Send( ply )
end

net.Receive( 'CAS-CALL', function( len, ply ) 
	local id = net.ReadUInt( 8 )
	
	if ( CAS.List[ id ] == nil ) then
		return
	end

	local item = CAS.List[ id ]

	if ( table.Count( item.rank_access ) != 0 and not ply:IsSuperAdmin() ) then
		if ( not table.HasValue( item.rank_access, ply:GetUserGroup() ) ) then
			sendText( ply, "You don't have enough privilege to access of kit." )

			return
		end
	end

	if ( item.money != 0 ) then
		if ( ply:getDarkRPVar( 'money' ) >= item.money ) then
			if ( ply:GetNWInt( 'CAS_ID' ) != id ) then
				ply:addMoney( -item.money )

				sendText( ply, 'Purchased and activated!' )
			end
		else
			sendText( ply, "Not enough money! Need: " .. DarkRP.formatMoney( item.money ) )

			return
		end
	elseif ( ply:GetNWInt( 'CAS_ID' ) != id ) then
		sendText( ply, '"' .. item.name .. '" activated' )
	end

	if ( ply:GetNWInt( 'CAS_ID' ) != id ) then
		timer.Simple( 0.1, function()
			ply:SetNWBool( 'CAS_ID', id )

			if ( ply:Alive() ) then
				ply:Spawn()
			end
		end )
	end
end )

net.Receive( 'CAS-UPDATE-KITS-SERVER', function( len, ply )
	if ( !ply:IsSuperAdmin() ) then
		sendText( ply, "You don't have access!" )

		return
	end

	local tabl_num = net.ReadUInt( 8 )
	local tabl = net.ReadTable()

	CAS.List = {}
	CAS.List = util.JSONToTable( file.Read( 'cas/kits.json', 'DATA' ) )
	CAS.List[ tabl_num ] = tabl

	file.Write( 'cas/kits.json', util.TableToJSON( CAS.List ) )

	sendText( ply, 'The kit data has been changed.' )
end )

net.Receive( 'CAS-UPDATE-REMOVE-KIT', function( len, ply )
	if ( !ply:IsSuperAdmin() ) then
		sendText( ply, "You don't have access!" )

		return
	end

	local tabl_num = net.ReadUInt( 8 )

	CAS.List = {}
	CAS.List = util.JSONToTable( file.Read( 'cas/kits.json', 'DATA' ) )

	table.remove( CAS.List, tabl_num )

	file.Write( 'cas/kits.json', util.TableToJSON( CAS.List ) )

	sendText( ply, 'This kit was deleting.' )
end )

net.Receive( 'CAS-UPDATE-SERVER-CMDS', function()
	CAS.Commands = net.ReadTable()
	
	file.Write( 'cas/commands.json', util.TableToJSON( CAS.Commands ) )
end )

hook.Add( 'PlayerSpawn', 'CAS', function( ply )
	timer.Simple( 0, function()
		if ( ply:GetNWInt( 'CAS_ID' ) != nil ) then
			for numList, item in pairs( CAS.List ) do
				if ( ply:GetNWInt( 'CAS_ID' ) == numList ) then
					ply:RemoveAllItems()

					for _, weapon in pairs( item.weapon ) do
						ply:Give( weapon.class )

						local ammo_type = ply:GetWeapon( weapon.class ):GetPrimaryAmmoType()

						ply:GiveAmmo( weapon.ammo, ammo_type )
					end

					if ( item.health != 0 ) then
						ply:SetHealth( item.health )
					end

					if ( item.armor != 0 ) then
						ply:SetArmor( item.armor )
					end
				end
			end
		end
	end )
end )

timer.Create( 'CasDataUpdate', 1, 0, function()
	CAS.List = {}
	CAS.List = util.JSONToTable( file.Read( 'cas/kits.json', 'DATA' ) )

	CAS.Commands = {}
	CAS.Commands = util.JSONToTable( file.Read( 'cas/commands.json', 'DATA' ) )

	net.Start( 'CAS-UPDATE' )
		net.WriteTable( { kits = CAS.List, commands = CAS.Commands } ) -- Compression is not suitable due to the need for client-server communication
	net.Broadcast()
end )

// Initial database installation

hook.Add( 'Initialize', 'CAS', function()
	if ( not file.IsDir( 'cas', 'DATA' ) ) then
		file.CreateDir( 'cas' )
	end

	if ( not file.Exists( 'cas/kits.json', 'DATA' ) ) then
		file.Write( 'cas/kits.json', '[{"rank_access":[],"armor":0.0,"health":0.0,"money":0.0,"name":"The first step","weapon":[{"ammo":"40","class":"weapon_357"},{"ammo":"0","class":"weapon_fists"},{"ammo":"0","class":"weapon_bugbait"}]},{"rank_access":["admin"],"name":"The perfect VIP","health":150.0,"money":0.0,"armor":50.0,"weapon":[{"ammo":"0","class":"weapon_fists"},{"ammo":"30","class":"weapon_pumpshotgun2"},{"ammo":"60","class":"weapon_p2282"}]},{"rank_access":[],"armor":45.0,"health":135.0,"money":5000.0,"name":"Hopelessness","weapon":[{"ammo":"4","class":"weapon_frag"},{"ammo":"0","class":"weapon_fists"}]},{"rank_access":["admin"],"armor":100.0,"health":180.0,"money":0.0,"name":"Admin is not a noob","weapon":[{"ammo":"0","class":"weapon_stunstick"},{"class":"weapon_fiveseven2"},{"class":"weapon_fists"},{"class":"weapon_mp52"}]},{"rank_access":["admin"],"name":"Instant explosion","health":200.0,"money":24000.0,"armor":80.0,"weapon":[{"ammo":"4","class":"weapon_rpg"},{"ammo":"6","class":"weapon_frag"},{"ammo":"0","class":"weapon_fists"}]}]' )
	end

	if ( not file.Exists( 'cas/commands.json', 'DATA' ) ) then
		file.Write( 'cas/commands.json', '["!cas","/cas","!kit_system","/kit_system"]' )
	end
end )

// Opening the menu via chat

hook.Add( 'PlayerSay', 'CAS', function( ply, txt )
	local txt = string.lower( txt )

	if ( table.HasValue( CAS.Commands, txt ) ) then
		ply:ConCommand( 'cas_menu' )
	end
end )
