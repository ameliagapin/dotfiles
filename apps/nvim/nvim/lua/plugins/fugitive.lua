return {
    {
        'tpope/vim-fugitive',
        dependencies = {
            'tpope/vim-rhubarb',
        },
        lazy = false,

        keys = {
            {
                "<leader>gh", "<cmd>GBrowse<cr>",
                desc = "Open line in Github",
                mode = { "n", "v" },
            },
        },
    },
}
