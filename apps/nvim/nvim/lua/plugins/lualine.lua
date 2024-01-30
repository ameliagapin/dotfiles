return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function()
            return {
                options = {
                    icons_enabled = true,
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        {
                            'filename',
                            path = 1,
                        },
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                extensions= {
                    'neo-tree',
                    'fugitive',
                    'trouble',
                },
            }
        end,
    },
}
