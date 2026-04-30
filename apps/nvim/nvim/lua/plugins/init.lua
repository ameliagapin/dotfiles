return {
    { "catppuccin/nvim",                name = "catppuccin", priority = 1000, lazy = false },
    { 'norcalli/nvim-colorizer.lua' },
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
    { "giuxtaposition/blink-cmp-copilot" },

    -- {
    --     "olexsmir/gopher.nvim",
    --     ft = "go",
    --     ---@module "gopher"
    --     ---@type gopher.Config
    --     opts = {},
    -- },
    {
        -- This is neat, but doesn't seem to work as well as I'd like with Go code.
        -- Check it out again later some time. https://github.com/error311/wayfinder.nvim
        "error311/wayfinder.nvim",
        opts = function()
            require("wayfinder").setup({
                performance = "fast",
                scope = {
                    mode = "package",
                    package_markers = {
                        "package.json",
                        "tsconfig.json",
                        "pyproject.toml",
                        "go.mod",
                        "Cargo.toml",
                        ".git",
                    },
                },
                limits = {
                    refs = { max_results = 200, timeout_ms = 1200 },
                    text = { enabled = true, max_results = 100, timeout_ms = 800 },
                    tests = { max_results = 50, timeout_ms = 700 },
                    git = { enabled = true, max_commits = 15, timeout_ms = 400 },
                },
            })
        end,
        keys = {
            { '<leader>wf', ":Wayfinder<CR>", desc = "Wayfinder" },
        }
    }
}
