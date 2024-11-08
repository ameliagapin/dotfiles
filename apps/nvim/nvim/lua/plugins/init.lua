return {
    { "catppuccin/nvim",            name = "catppuccin", priority = 1000, lazy = false },
    { 'folke/which-key.nvim',       opts = {} },
    { 'norcalli/nvim-colorizer.lua' },
    { 'sebdah/vim-delve' },
    { 'tpope/vim-fugitive' },
    -- Highlight other instances of the word under the cursor
    { 'RRethy/vim-illuminate' },
    -- { 'f-person/git-blame.nvim'},
    { 'sindrets/diffview.nvim' },
    { 'akinsho/git-conflict.nvim',  version = "*",       config = true },
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    },
}
