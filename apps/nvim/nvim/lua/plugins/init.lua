return {
    { "catppuccin/nvim",                name = "catppuccin", priority = 1000, lazy = false },
    { 'folke/which-key.nvim',           opts = {} },
    { 'norcalli/nvim-colorizer.lua' },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },
    -- Highlight other instances of the word under the cursor
    { 'RRethy/vim-illuminate' },

    { 'HiPhish/rainbow-delimiters.nvim' },
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
    { "mrbjarksen/neo-tree-diagnostics.nvim" },
    -- Enable for snow in nvim!!! (it's fun!)
    -- {
    --     "marcussimonsen/let-it-snow.nvim",
    --     cmd = "LetItSnow", -- Wait with loading until command is run
    --     opts = {
    --         delay = 200,
    --     },
    -- },

    { 'akinsho/git-conflict.nvim',           version = "*", config = true },

    -- Evaluating?

    { 'sindrets/diffview.nvim' },
    {
        "giuxtaposition/blink-cmp-copilot",
    },


    {
        "WilliamHsieh/overlook.nvim",
        opts = {},

        -- Optional: set up common keybindings
        keys = {
            { "<leader>pd", function() require("overlook.api").peek_definition() end, desc = "Overlook: Peek definition" },
            { "<leader>pc", function() require("overlook.api").close_all() end,       desc = "Overlook: Close all popup" },
            { "<leader>pu", function() require("overlook.api").restore_popup() end,   desc = "Overlook: Restore popup" },
        },
    },

    {
        "olexsmir/gopher.nvim",
        ft = "go",
        ---@module "gopher"
        ---@type gopher.Config
        opts = {},
    },
}
