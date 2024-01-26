return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
        keys= {
            { "<C-b>", "<cmd>Telescope buffers<cr>",    desc = "Show buffers in telescope" },
            { "<C-p>", "<cmd>Telescope find_files<cr>",    desc = "Find files in telescope" },
            { "<leader>/", "<cmd>Telescope live_grep<cr>",    desc = "Find files in telescope" },
        },
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup {
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = { height = 0.95 },
                    mappings = {
                        i = {
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                            ['<esc><esc>'] = actions.close,
                        },
                    },
                    file_ignore_patterns = { "/vendor/", "vendor/", "^vendor/" },
                },
            }
            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')
            local builtin = require('telescope.builtin')
            -- vim.keymap.set('n', '<C-p>', builtin.find_files, {})
            -- vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
        end
    },
}
