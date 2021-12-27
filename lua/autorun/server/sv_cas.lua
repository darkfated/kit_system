util.AddNetworkString( 'cas_call' )
util.AddNetworkString( 'cas_buy' )

net.Receive( 'cas_call', function( len, ply )
	local id = net.ReadFloat()
	local retur = true

	if ( CAS.List[ id ] == nil ) then
		return
	end 

	if ( ply:IsSuperAdmin() ) then
		retur = false
	else
		if ( CAS.List[ id ].rank == nil ) then
			retur = false
		else
			for o, rank in pairs( CAS.List[ id ].rank ) do
				if ( ply:GetUserGroup() == rank ) then
					retur = false
				end
			end
		end
	end

	if ( retur ) then
		ply:ChatPrint( 'You do not have enough rights to choose this equipment!' )

		return
	end

	if ( ply:Alive() ) then
		timer.Simple( 0.1, function()
			ply:SetNWString( 'player_casid', id )

			ply:Spawn()
		end )
	end
end )

net.Receive( 'cas_buy', function( len, ply )
	local id = net.ReadFloat()
	local dop = net.ReadBool()
	local ActiveTabl = dop and CAS.DopList or CAS.List

	if ( ActiveTabl[ id ] == nil ) then
		return
	end

	if ( ply:getDarkRPVar( 'money' ) >= ActiveTabl[ id ].money ) then
		if ( ply:GetNWBool( 'cas_dop_' .. id ) ) then
			return
		end

		ply:addMoney( -ActiveTabl[ id ].money )

		if ( dop ) then
			ply:SetNWBool( 'cas_dop_' .. id, true )
		else
			ply:SetNWBool( id, true )
		end

		ply:ChatPrint( 'You bought this gear. Now you can use it!' )
	else
		ply:ChatPrint( "You don't have enough money! Need: " .. DarkRP.formatMoney( ActiveTabl[ id ].money ) )
	end
end )

hook.Add( 'PlayerSpawn', 'CAS.Spawn', function( ply )
	timer.Simple( 0, function()
		if ( ply:GetNWString( 'player_casid' ) != nil ) then
			for numList, item in pairs( CAS.List ) do
				if ( numList == ply:GetNWString( 'player_casid' ) ) then
					ply:RemoveAllItems()

					for _, weapon in pairs( item.weapon ) do
						ply:Give( weapon )
					end
				
					for _, plyWeapon in pairs( ply:GetWeapons() ) do
						local ammo_type = plyWeapon:GetPrimaryAmmoType()

						ply:GiveAmmo( 1000, ammo_type )
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

		for num, item_dop in pairs( CAS.DopList ) do
			if ( ply:GetNWBool( 'cas_dop_' .. num ) ) then
				ply:Give( item_dop.weapon )
			end
		end
	end )
end )
