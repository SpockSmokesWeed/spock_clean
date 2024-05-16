fx_version 'adamant'
game 'gta5'

author 'Spock'
description 'Clear Ped Vehicles Script'
version '1.0.0'

shared_scripts {
    'shared/config.lua' -- Ensure config is loaded first
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

files {
    'html/ui.html',
    'html/styles.css',
    'html/scripts.js',
    'html/select.wav',
    'locales/en.lua',
    'locales/pt.lua',
    'locales/de.lua',
    'locales/fr.lua',
    'locales/es.lua'
}

ui_page 'html/ui.html'
