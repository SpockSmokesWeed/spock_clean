
Config = {}

Config.Language = 'en' -- Default language: 'en', 'pt', 'de', 'fr', 'es'

Config.Framework = 'esx' -- Options: 'esx', 'qb', 'standalone'

-- Option 1: Detection radius for AI ped vehicles
Config.DetectionRadius = 100.0  -- Default is 100.0, can be adjusted as needed (WARNING: CPU useage may increase!)

-- Option 2: Enable or disable menu click sound
Config.MenuClickSound = true  -- Set to false to disable sound

-- Option 3: Admin-only command
Config.AdminOnly = false  -- Set to false to allow all players to use the command (default = false)

-- Option 4: Blacklist vehicle models from being deleted
Config.BlacklistedVehicles = {
    "police",
    "police2",
    "police3",
    "police4",
    "fbi1",
    "fbi2",
    "ambulance",
    "riot",
    --"moddedcar1",  -- Add modded vehicle names here
    --"moddedcar2"
}

-- Option 5: Notification system

Config.NotificationSystem = 'okokNotify'  -- Options: 'okokNotify', 'esx'

