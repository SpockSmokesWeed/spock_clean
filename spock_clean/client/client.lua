Locales = Locales or {}

local function loadLocale(language)
    local localeFile = LoadResourceFile(GetCurrentResourceName(), 'locales/' .. language .. '.lua')
    if localeFile then
        local localeFunc = load(localeFile)
        if localeFunc then
            localeFunc()
        end
    else
        print("Locale file for " .. language .. " not found!")
    end
end

Citizen.CreateThread(function()
    loadLocale(Config.Language)
end)

local playerVehicles = {}
local isClearingPeds = false
local isMenuOpen = false

function ToggleMenu()
    isMenuOpen = not isMenuOpen
    SetNuiFocus(isMenuOpen, isMenuOpen)
    if isMenuOpen then
        DisplayRadar(false)
        SetPlayerControl(PlayerId(), false, 0)
    else
        DisplayRadar(true)
        SetPlayerControl(PlayerId(), true, 0)
    end
    SendNUIMessage({
        type = "ui",
        display = isMenuOpen,
        config = Config,
        locales = Locales[Config.Language]
    })
end

RegisterCommand("clearped", function()
    ToggleMenu()
end)

RegisterNUICallback('startClearingPeds', function(data, cb)
    isClearingPeds = true
    Notify(Locales[Config.Language].start_clearing, 'success')
    Citizen.CreateThread(function()
        while isClearingPeds do
            Citizen.Wait(1000)  -- Check every second
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            local radius = Config.DetectionRadius  -- Use the configured radius

            -- Track player's last vehicle when they exit
            local lastVehicle = GetVehiclePedIsIn(playerPed, true)
            if lastVehicle ~= 0 and not playerVehicles[lastVehicle] then
                playerVehicles[lastVehicle] = true
                TriggerServerEvent('trackPlayerVehicle', lastVehicle)
            end

            -- Get vehicles in the area and filter locally to reduce server calls
            local vehicles = GetVehiclesInArea(playerPos, radius)
            for _, vehicle in ipairs(vehicles) do
                local vehicleClass = GetVehicleClass(vehicle)
                local vehicleModel = GetEntityModel(vehicle)
                if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
                    if vehicleClass ~= 18 and vehicleClass ~= 15 and vehicleClass ~= 16 then
                        -- Exclude blacklisted vehicles
                        if not IsBlacklistedVehicle(vehicleModel) then
                            if not playerVehicles[vehicle] then
                                DeleteEntity(vehicle)
                            end
                        end
                    end
                end
            end
        end
    end)
    cb('ok')
end)

RegisterNUICallback('stopClearingPeds', function(data, cb)
    isClearingPeds = false
    Notify(Locales[Config.Language].stop_clearing, 'error')
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    isMenuOpen = false
    SetNuiFocus(false, false)
    DisplayRadar(true)
    SetPlayerControl(PlayerId(), true, 0)
    SendNUIMessage({
        type = "ui",
        display = false
    })
    cb('ok')
end)

RegisterNetEvent('trackPlayerVehicle')
AddEventHandler('trackPlayerVehicle', function(vehicle)
    playerVehicles[vehicle] = true
end)


-- Handle synchronization of player vehicles
RegisterNetEvent('syncPlayerVehicles')
AddEventHandler('syncPlayerVehicles', function(vehicles)
    playerVehicles = vehicles
end)

function Notify(message, type)
    type = type or 'info'
    if Config.NotificationSystem == 'okokNotify' then
        if type == 'success' then
            exports['okokNotify']:Alert(Locales[Config.Language].menu_title, message, 5000, 'success', true)
        elseif type == 'error' then
            exports['okokNotify']:Alert(Locales[Config.Language].menu_title, message, 5000, 'error', true)
        else
            exports['okokNotify']:Alert(Locales[Config.Language].menu_title, message, 5000, type)
        end
    elseif Config.NotificationSystem == 'esx' then
        if Config.Framework == 'esx' then
            ESX.ShowNotification(message)
        elseif Config.Framework == 'qbcore' then
            QBCore.Functions.Notify(message, type)
        elseif Config.Framework == 'standalone' then
            -- Custom notification for standalone
            print("Notification: " .. message)
        end
    else
        print("Notification: " .. message)
    end
end


-- Utility function to get vehicles in an area
function GetVehiclesInArea(coords, radius)
    local vehicles = {}
    local handle, vehicle = FindFirstVehicle()
    local success
    repeat
        local vehiclePos = GetEntityCoords(vehicle)
        if Vdist(coords.x, coords.y, coords.z, vehiclePos.x, vehiclePos.y, vehiclePos.z) <= radius then
            table.insert(vehicles, vehicle)
        end
        success, vehicle = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return vehicles
end

-- Utility function to check if a vehicle is blacklisted
function IsBlacklistedVehicle(vehicleModel)
    for _, blacklistedModel in ipairs(Config.BlacklistedVehicles) do
        if GetHashKey(blacklistedModel) == vehicleModel then
            return true
        end
    end
    return false
end


-- Clear player vehicles list when script is stopped
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        playerVehicles = {}
        TriggerServerEvent('untrackPlayerVehicle', currentVehicle)
    end
end)
