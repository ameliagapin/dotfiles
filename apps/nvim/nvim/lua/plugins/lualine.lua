return {
    {
        'nvim-lualine/lualine.nvim',
        url = 'https://github.com/nvim-lualine/lualine.nvim',
        build = {
            -- PR that includes more customization options for the `location` component
            -- https://github.com/nvim-lualine/lualine.nvim/pull/1334
            'git pull --no-rebase --no-commit origin pull/1334/head',
        },
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function()
            return {
                options = {
                    icons_enabled = true,
                    line_total_in_location = true,
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
                    lualine_x = {
                        {
                            'lsp_status',
                            icon = '', -- f013
                            symbols = {
                                -- Standard unicode symbols to cycle through for LSP progress:
                                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                                -- Standard unicode symbol for when LSP is done:
                                done = '✓',
                                -- Delimiter inserted between LSP names:
                                separator = ' ',
                            },
                            -- List of LSP names to ignore (e.g., `null-ls`):
                            ignore_lsp = {},
                        },
                        'filetype',
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                extensions = {
                    'neo-tree',
                    'fugitive',
                    'trouble',
                },
            }
        end,
    },
}
