return {
    { "catppuccin/nvim",            name = "catppuccin", priority = 1000, lazy = false },
    { 'folke/which-key.nvim',       opts = {} },
    { 'norcalli/nvim-colorizer.lua' },
    { 'tpope/vim-fugitive' },
    -- Highlight other instances of the word under the cursor
    { 'RRethy/vim-illuminate' },
    {
        "aaronik/treewalker.nvim",
        opts = {
            highlight = true -- Whether to briefly highlight the node after jumping to it
        },
        keys = {
            { '<C-,>', ':Treewalker Up<CR>',   desc = "Treewalker" },
            { '<C-.>', ':Treewalker Down<CR>', desc = "Treewalker" },
            -- {'<C-h>', ':Treewalker Left<CR>', desc = "Treewalker"},
            -- {'<C-l>', ':Treewalker Right<CR>', desc = "Treewalker"},
        },
    },
    -- Enable for snow in nvim!!! (it's fun!)
    -- {
    --     "marcussimonsen/let-it-snow.nvim",
    --     cmd = "LetItSnow", -- Wait with loading until command is run
    --     opts = {
    --         delay = 200,
    --     },
    -- },

    -- Evaluating?

    { 'sindrets/diffview.nvim' },
    { 'akinsho/git-conflict.nvim', version = "*", config = true },
    --    { 'sebdah/vim-delve' },
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    },

    { "mrbjarksen/neo-tree-diagnostics.nvim" },
    {
        "giuxtaposition/blink-cmp-copilot",
    } }
