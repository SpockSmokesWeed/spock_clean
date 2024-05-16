local playerVehicles = {}

RegisterNetEvent('trackPlayerVehicle')
AddEventHandler('trackPlayerVehicle', function(vehicle)
    playerVehicles[source] = playerVehicles[source] or {}
    table.insert(playerVehicles[source], vehicle)
end)

RegisterNetEvent('untrackPlayerVehicle')
AddEventHandler('untrackPlayerVehicle', function(vehicle)
    if playerVehicles[source] then
        for i, v in ipairs(playerVehicles[source]) do
            if v == vehicle then
                table.remove(playerVehicles[source], i)
                break
            end
        end
    end
end)

-- Example admin check for standalone
local function isAdmin(playerId)
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        return xPlayer and xPlayer.getGroup() == 'admin'
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        return Player and Player.PlayerData.job.name == 'admin'
    elseif Config.Framework == 'standalone' then
        -- Implement your own admin check for standalone
        return IsPlayerAceAllowed(playerId, "admin")
    end
end

RegisterCommand('clearped', function(source)
    if Config.AdminOnly and not isAdmin(source) then
        Notify("You do not have permission to use this command.", 'error')
        return
    end
    -- Rest of the command handling
end)

