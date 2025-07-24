return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
    },
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- Disable the annoying warning for vim not being a defined global
            diagnostics = { disable = { 'undefined-global' } },
        },
    },
}
