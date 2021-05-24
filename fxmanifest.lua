fx_version 'adamant'

game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'RDX THIEF'

version '1.0.1'

client_scripts {
    '@rdx_core/locale.lua',
    'locales/br.lua',
    'config.lua',
    'client/main.lua',
    'handsup.lua'
}

server_scripts {
    '@rdx_core/locale.lua',
    'locales/br.lua',
    'config.lua',
    'server/main.lua'
}
