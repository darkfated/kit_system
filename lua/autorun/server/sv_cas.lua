util.AddNetworkString( 'cas_call' )
util.AddNetworkString( 'cas_buy' )

net.Receive( 'cas_call', function( len, ply )
    local tabl = net.ReadTable()
    local health = net.ReadFloat()
    local armor = net.ReadFloat()
    local ranks = net.ReadTable()
    local id = net.ReadFloat()
    local retur = true

    for o, p in pairs( ranks ) do
        if ( ply:GetUserGroup() == p ) then
            retur = false
        end

        if ( ply:IsSuperAdmin() ) then
            retur = false
        end
    end

    if ( retur ) then
        ply:ChatPrint( 'You do not have enough rights to choose this equipment!' )

        return
    end

    if ( ply:Alive() ) then
        timer.Simple( 0.1, function()
            ply:SetNWString( 'player_casid', id )

            ply:Kill()
        end )
    end
end )

net.Receive( 'cas_buy', function( len, ply )
    local id = net.ReadFloat()
    local money = net.ReadFloat()
    local dop = net.ReadBool()
    local yes = true

    if ( dop ) then
        for k, v in pairs( CAS.DopList ) do
            if ( v.id == id and v.money == money ) then
                yes = false
            end
        end
    else
        for k, v in pairs( CAS.List ) do
            if ( v.id == id and v.money == money ) then
                yes = false
            end
        end    
    end

    if ( yes ) then
        return
    end

    if ( ply:getDarkRPVar( 'money' ) >= money ) then
        if ( ply:GetNWBool( 'cas_dop_' .. id ) ) then
            return
        end

        ply:addMoney( -money )

        if ( dop ) then
            ply:SetNWBool( 'cas_dop_' .. id, true )
        else
            ply:SetNWBool( id, true )
        end

        ply:ChatPrint( 'You bought this gear. Now you can use it!' )
    else
        ply:ChatPrint( "You don't have enough money! Need: " .. DarkRP.formatMoney( money ) )
    end
end )

hook.Add( 'PlayerSpawn', 'CAS.Spawn', function( ply )
    timer.Simple( 0, function()
        if ( ply:GetNWString( 'player_casid' ) != nil ) then
            for k, v in pairs( CAS.List ) do
                if ( v.id == ply:GetNWString( 'player_casid' ) ) then
                    ply:RemoveAllItems()

                    for X, Z in pairs( v.weapon ) do
                        ply:Give( Z )
                    end
                
                    for X, Z in pairs( ply:GetWeapons() ) do
                        local ammo_type = Z:GetPrimaryAmmoType()
                
                        ply:GiveAmmo( 1000, ammo_type )
                    end

                    local health = v.health
                
                    if ( health != 0 ) then
                        ply:SetHealth( health )
                    else
                        ply:SetHealth( 100 )
                    end

                    local armor = v.armor
                
                    if ( armor != 0 ) then
                        ply:SetArmor( armor )
                    else
                        ply:SetArmor( 0 )
                    end
                end
            end
        end

        for z, x in pairs( CAS.DopList ) do
            if ( ply:GetNWBool( 'cas_dop_' .. x.id ) ) then
                ply:Give( x.weapon )
            end
        end
    end )
end )
