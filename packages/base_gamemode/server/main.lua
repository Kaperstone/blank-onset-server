-- Blank onset server, written by Kaperstone
-- Onset Forums: https://forum.playonset.com/forum/onset/scripting/releases/274-base-script
-- GitHub Profile: https://github.com/kaperstone
-- GitHub Repository: https://github.com/kaperstone/blank-onset-server

--

-- Initilizing global arrays

config = {
    -- The SteamId64 of your Steam account
    adminSteamId = 76561198102442831,
    -- MariaDB credentials
    mariadb = { host = "127.0.0.1:3306", user = "root", password = "", database = "default" },
    -- Logging options
    log = { kicks = true, bans = true, unbans = true, warns = true },
    max_warnings = 3,
    -- The minimum and maximum length a reason can be for { kick, ban, unban, warn }
    min_reason = 3,
    max_reason = 128,
    admin_level = { kick = 1, ban = 2, unban = 3, warn = 1}
}

db = false
PlayerData = { }

local PlayerColors = {
    "#f19066",
    "#f5cd79",
    "#546de5",
    "#e15f41",
    "#c44569",
    "#574b90",
    "#f78fb3",
    "#3dc1d3",
    "#e66767",
    "#303952"
}

-- Package events


function OnPackageStart()
    mariadb_log("debug")

    print((":: Onset server `%s` running version %s\n"):format(GetServerName(), GetGameVersionString()))
    print("> Attempting to connect to MariaDB server")

    db = mariadb_connect(config.mariadb.host, config.mariadb.user, config.mariadb.password, config.mariadb.database)

    if(db ~= false) then
        print("> Successfully connected to MariaDB")
        mariadb_set_charset(db, "utf8mb4")
        mariadb_await_query_file(db, "./setup/accounts.sql")
    else
        print("> Failed to connect to MariaDB, stopping the server ...")
        ServerExit()
    end
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()
    print(":: Stopping the server")
    mariadb_close(db)
end
AddEvent("OnPackageStop", OnPackageStop)

-- Player events

function OnPlayerJoin(player)
    -- Set where the player is going to spawn.
    SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)

    AddPlayerChatAll("<span color='#eeeeeeaa'>"..GetPlayerName(player).." ("..player..") joined the server</>")
    AddPlayerChatAll("<span color='#eeeeeeaa'>There are "..GetPlayerCount().." players on the server</>")
    AddPlayerChat(player, "Welcome to `"..GetServerName().."`")
    AddPlayerChat(player, "Game version: "..GetPlayerGameVersion()..", Locale: "..GetPlayerLocale(player))

    PlayerData[player] = {}
    PlayerData[player].isSteamAuth = false
    PlayerData[player] = PlayerColors[Random(0, table.getn(PlayerColors))]
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

function OnPlayerQuit(player)
    AddPlayerChatAll(GetPlayerName(player).." left the server.")
    SaveAccount(player)
    PlayerData[player] = nil
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnPlayerSpawn(player)
    AddPlayerChat(player, "You have spawned")
end
AddEvent("OnPlayerSpawn", OnPlayerSpawn)

function OnPlayerDeath(player, killer)
    AddPlayerChatAll(("Player %s(%d) killed player %s(%d)"):format(
        GetPlayerName(killer),
        killer,
        GetPlayerName(player),
        player
    ))

    PlayerData[player].deaths = PlayerData[player].deaths - 1
    PlayerData[killer].kills = PlayerData[killer].kills - 1

    GivePlayerScore(killer, 1)
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

function OnPlayerWeaponShot(player, weapon, hittype, hitid, hitX, hitY, hitZ, startX, startY, normalX, normalY, normalZ)

end
AddEvent("OnPlayerWeaponShot", OnPlayerWeaponShot)

function OnPlayerDamage(player, damagetype, amount)

end

AddEvent("OnPlayerDamage", OnPlayerDamage)

function OnPlayerChat(player, text)
    AddPlayerChatAll(player, ("<span color='%s'>%s</>: %s"):format(
        PlayerData[player].color,
        GetPlayerName(player),
        text
    ))
end

AddEvent("OnPlayerChat", OnPlayerChat)

function OnPlayerChatCommand(player, cmd, exists)
    if(not PlayerData[player].isSteamAuth) then
        return AddPlayerChat("Your Steam account hasn't been authenticated yet.")
    end

    if (GetTimeSeconds() - PlayerData[player].cmd_cooldown < 0.5) then
        CancelChatCommand()
        return AddPlayerChat(player, "Slow down with your commands")
    end

    PlayerData[player].cmd_cooldown = GetTimeSeconds()

    if (exists == 0) then
        AddPlayerChat(player, "Command `/"..cmd.."` not found!")
    end
end
AddEvent("OnPlayerChatCommand", OnPlayerChatCommand)

-- Vehicle events

function OnPlayerEnterVehicle(player, vehicle, seat)

end
AddEvent("OnPlayerEnterVehicle", OnPlayerEnterVehicle)

function OnPlayerLeaveVehicle(player, vehicle, seat)

end
AddEvent("OnPlayerLeaveVehicle", OnPlayerLeaveVehicle)

function OnPlayerStateChange(player, newstate, oldstate)

end
AddEvent("OnPlayerStateChange", OnPlayerStateChange)

function OnVehicleRespawn(vehicle)

end
AddEvent("OnVehicleRespawn", OnVehicleRespawn)

function OnVehicleStreamIn(vehicle, player)

end
AddEvent("OnVehicleStreamIn", OnVehicleStreamIn)

function OnVehicleStreamOut(vehicle, player)

end
AddEvent("OnVehicleStreamOut", OnVehicleStreamOut)


-- Server events

function OnGameTick(DeltaSeconds)

end
AddEvent("OnGameTick", OnGameTick)

function OnClientConnectionRequest(ip, port)

end
AddEvent("OnClientConnectionRequest", OnClientConnectionRequest)

function OnPlayerServerAuth(player)

end
AddEvent("OnPlayerServerAuth", OnPlayerServerAuth)

function OnPlayerSteamAuth(player)
    AddPlayerChat(player, "Your SteamId: "..GetPlayerSteamId(player))

    local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE steamid = ? LIMIT 1", GetPlayerSteamId())
    mariadb_async_query(db, query, OnAccountLoad, player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

function OnPlayerDownloadFile()

end
AddEvent("OnPlayerDownloadFile", OnPlayerDownloadFile)

-- Pickup events

function OnPlayerPickupHit()

end
AddEvent("OnPlayerPickupHit", OnPlayerPickupHit)

function OnVehiclePickupHit()

end
AddEvent("OnVehiclePickupHit", OnVehiclePickupHit)

-- Stream events

function OnPlayerStreamIn(player, otherplayer)

end
AddEvent("OnPlayerStreamIn", OnPlayerStreamIn)

function OnPlayerStreamOut(player, otherplayer)

end
AddEvent("OnPlayerStreamOut", OnPlayerStreamOut)


-- NPC events

function OnNPCReachTarget()

end
AddEvent("OnNPCReachTarget", OnNPCReachTarget)

function OnNPCDamage()

end
AddEvent("OnNPCDamage", OnNPCDamage)

function OnNPCSpawn()

end
AddEvent("OnNPCSpawn", OnNPCSpawn)

function OnNPCDeath()

end
AddEvent("OnNPCDeath", OnNPCDeath)


function cmd_SpawnVehicle(player, vehicle)
    -- Usage: /v [vehicleid]

    if(vehicle == nil) then
        return AddPlayerChat(player, "Usage: /v <vehicleid (1-16)>")
    end

    if(not (0 < vehicle and vehicle <= 16)) then
        return AddPlayerChat(player, "Vehicle ID should be from 1 to 16")
    end

    local position = GetPlayerLocation(player)

    CreateVehicle(vehicle, position.x, position.y, position.z)

end
AddCommand("vehicle", cmd_SpawnVehicle)
AddCommand("veh", cmd_SpawnVehicle)
AddCommand("v", cmd_SpawnVehicle)

function cmd_SetModel(player, model)
    -- Usage: /m [model]

    if(model == nil) then
        return AddPlayerChat(player, "Usage: /m <modelid (0-3)>")
    end

    if(not (0 < model and model <= 3)) then
        return AddPlayerChat(player, "Model ID should be from 1 to 3")
    end

    SetPlayerModel(player, model)
end
AddCommand("model", cmd_SetModel)
AddCommand("m", cmd_SetModel)

function cmd_SetHeadSize(player, size)
    -- Usage: /resizemyhead [size]

    if(size == nil) then
        return AddPlayerChat(player, "Usage: /resizemyhead <size (1-10)>>")
    end

    if(not (0 < size and size <= 10)) then
        return AddPlayerChat(player, "Model ID should be from 1 to 10")
    end

    SetPlayerHeadSize(player, size)
end
AddCommand("resizemyhead", cmd_SetHeadSize)

function cmd_kmp(player)
    -- Usage: /kill

    SetPlayerHealth(player, 0.0)
end
AddCommand("kill", cmd_kmp)

function cmd_Stats(player, target)
    -- Usage: /stats [playerid]
    -- playerid is optional

    local id
    if(target == nil) then
        id = player
    else
        id = target
    end


    AddPlayerChat(player, ("%s's statistics:"):format(GetPlayerName(player)))
    AddPlayerChat(player, ("Admin Level %d"):format(PlayerData[id].admin))
    AddPlayerChat(player, ("Join date %s"):format(PlayerData[id].joindate))
    AddPlayerChat(player, ("Last seen %s"):format(PlayerData[id].lastseen))
    AddPlayerChat(player, ("Score %d | Cash %d"):format(PlayerData[id].score, PlayerData[id].cash))
    AddPlayerChat(player, ("Kills %d | Deaths %d"):format(PlayerData[id].kills, PlayerData[id].deaths))

    -- Admin stuff

    if(PlayerData[player].admin >= 1) then
        AddPlayerChat(player, ("Current IP %d"):format(GetPlayerIP(id)))
        AddPlayerChat(player, ("Previous IP %d"):format(PlayerData[id].lastseen_ip))
        AddPlayerChat(player, ("Join IP %d"):format(PlayerData[id].join_ip))
    end
end
AddCommand("stats", cmd_Stats)

function cmd_Kick(player, target, ...)
    -- Usage: /kick <playerid> <reason>

    if(not (PlayerData[player].admin >= config.admin_level.kick)) then
        return AddPlayerChat(player, "Insufficient permissions")
    end

    if(target == nil or #{...} == 0) then
        return AddPlayerChat(player, "Usage: /kick <playerid> <reason>")
    end

    target = tonumber(target)

    if(not (config.min_reason < #{...} and #{...} <= config.max_reason)) then
        return AddPlayerChat(player, "The reason should be between 3 characters to 128")
    end

    if(PlayerData[target].admin > PlayerData[player].admin) then
        return AddPlayerChat(player, "Cannot kick an admin higher in level than you")
    end

    -- Log
    if(config.log.kicks == true) then
        local query = mariadb_prepare(db, "INSERT INTO kicks (targetid, adminid, reason) VALUES (?, ?, ?)",
            GetPlayerSteamId(target),
            GetPlayerSteamId(player),
            {...}
        )
        mariadb_async_query(db, query)
    end

    -- Action
    KickPlayer(target, "You have been kicked from the server for: "..{...})
    AddPlayerChatAll(("Player %s(%d) has been kicked for: %s"):format(GetPlayerName(target), target, {...}))
end
AddCommand("kick", cmd_Kick)

function cmd_Ban(player, target, ...)
    -- Usage: /ban <playerid> <reason>

    if(not (PlayerData[player].admin >= config.admin_level.ban)) then
        return AddPlayerChat(player, "Insufficient permissions")
    end

    if(target == nil or #{...} == 0) then
        return AddPlayerChat(player, "Usage: /ban <playerid> <reason>")
    end

    target = tonumber(target)

    if(not (config.min_reason < #{...} and #{...} <= config.max_reason)) then
        return AddPlayerChat(player, "The reason should be between 3 characters to 128")
    end

    if(PlayerData[target].admin > PlayerData[player].admin) then
        return AddPlayerChat(player, "Cannot ban an admin higher in level than you")
    end

    -- Action
    mariadb_async_query(db, mariadb_prepare(db, "INSERT INTO bans (targetid, adminid, reason) VALUES (?, ?, ?)",
        GetPlayerSteamId(target),
        GetPlayerSteamId(player),
        {...}
    ))
    KickPlayer(target, "You have been banned from the server for: "..{...})
    AddPlayerChatAll(("Player %s(%d) has been banned for: %s"):format(GetPlayerName(target), target, {...}))
end
AddCommand("ban", cmd_Ban)

function cmd_Unban(player, target, ...)
    -- Usage: /unban <steamid> <reason>

    if(not (PlayerData[player].admin >= config.admin_level.unban)) then
        return AddPlayerChat(player, "Insufficient permissions")
    end

    if(target == nil or #{...} == 0) then
        return AddPlayerChat(player, "Usage: /unban <steamid> <reason>")
    end

    target = tonumber(target)

    if(not (config.min_reason < #{...} and #{...} <= config.max_reason)) then
        return AddPlayerChat(player, "The reason should be between 3 characters to 128")
    end

    -- Log
    if(config.log.unbans == true) then
        mariadb_async_query(db, mariadb_prepare(db, "INSERT INTO unbans (targetid, adminid, reason) VALUES (?, ?, ?)",
            GetPlayerSteamId(target),
            GetPlayerSteamId(player),
            {...}
        ))
    end

    -- Action
    local query = mariadb_prepare(db, "UPDATE bans SET lifted = true WHERE targetid = ?", target)
    mariadb_async_query(db, query, OnUnbanAccount, player, target)
end
AddCommand("unban", cmd_Unban)

function OnUnbanAccount(player, target)
    AddPlayerChat(player, "SteamID "..target.." has been unbanned")
end

function cmd_Warn(player, target, ...)
    -- Usage: /warn <playerid> <reason>

    if(not (PlayerData[player].admin >= config.admin_level.warn)) then
        return AddPlayerChat(player, "Insufficient permissions")
    end

    if(target == nil or #{...} == 0) then
        return AddPlayerChat(player, "Usage: /warn <playerid> <reason>")
    end

    target = tonumber(target)

    if(not (config.min_reason < #{...} and #{...} <= config.max_reason)) then
        return AddPlayerChat(player, "The reason should be between 3 characters to 128")
    end

    if(PlayerData[target].admin > PlayerData[player].admin) then
        return AddPlayerChat(player, "Cannot kick an admin higher in level than you")
    end

    -- Log
    if(config.log.warns == true) then
        mariadb_async_query(db, mariadb_prepare(db, "INSERT INTO warns (targetid, adminid, reason) VALUES (?, ?, ?)",
            GetPlayerSteamId(target),
            GetPlayerSteamId(player),
            {...}
        ))
    end

    -- Action
    PlayerData[target].warnings = PlayerData[target].warnings + 1
    if(PlayerData[target].warnings > config.max_warnings) then
        KickPlayer(target, "You have been kicked from the server for having too many warnings")
        AddPlayerChatAll(("Player %s(%d) has been kicked for too many warnings"):format(
            GetPlayerName(target),
            target,
            {...}
        ))
    end
end
AddCommand("warn", cmd_Warn)

function OnAccountLoad(player)
    -- If account exists
    if(maraidb_get_row_count() == 0) then
        -- User doesn't exist
        -- Create a new account automatically
        local query = mariadb_prepare(db, "INSERT INTO accounts (steamid, join_ip, lastseen_ip) VALUES (?, ?, ?)",
            GetPlayerSteamId(player),
            GetPlayerIP(),
            GetPlayerIP()
        )
        mariadb_async_query(db, query)

        PlayerData[player].admin = 0
        PlayerData[player].playtime = 0
        PlayerData[player].cash = 0
        PlayerData[player].score = 0
        PlayerData[player].kills = 0
        PlayerData[player].deaths = 0
        PlayerData[player].joindate = os.time()
        PlayerData[player].join_ip = GetPlayerIP(player)
    else
        -- User has an account
        -- Load its data
        local result = mariadb_get_assoc(1)

        PlayerData[player].admin = tonumber(result.admin)
        PlayerData[player].playtime = tonumber(result.playtime)
        PlayerData[player].cash = tonumber(result.cash)
        PlayerData[player].score = tonumber(result.score)
        PlayerData[player].kills = tonumber(result.kills)
        PlayerData[player].deaths = tonumber(result.deaths)
        PlayerData[player].joindate = tonumber(result.joindate)
        PlayerData[player].join_ip = result.join_ip
        PlayerData[player].lastseen_ip = result.lastseen_ip
    end

    -- default
    PlayerData[player].lastseen = os.time()
    PlayerData[player].cmd_cooldown = 0
    PlayerData[player].warnings = 0

    local query = mariadb_prepare(db, "UPDATE accounts SET lastseen_ip = ? WHERE steamid = ? LIMIT 1",
        GetPlayerIP(player),
        GetPlayerSteamId(player)
    )
    mariadb_async_query(db, query)

    -- Eligable to use commands
    PlayerData[player].isSteamAuth = true

    SetPlayerLocation(player, 125773.0, 80246.0, 1645.0)
    SetPlayerFacingAngle(player, 90.0)
end

function SaveAccount(player)
    local query = mariadb_query(db, "UPDATE accounts SET admin = ?, playtime = ?, cash = ?, score = ?, kills = ?, deaths = ?, lastseen = ?, lastseen_ip = ? WHERE steamid = ? LIMIT 1",
        PlayerData[player].admin,
        PlayerData[player].playtime,
        PlayerData[player].cash,
        PlayerData[player].score,
        PlayerData[player].kills,
        PlayerData[player].deaths,
        os.time(),
        GetPlayerIP(player),
        GetPlayerSteamId(player)
    )
    mariadb_async_query(db, query)
end

function GivePlayerScore(player, score)
    PlayerData[player].score = PlayerData[player].score + score
end
