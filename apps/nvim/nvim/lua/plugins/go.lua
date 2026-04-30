return {
    "ray-x/go.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
    },
    opts = {
        run_in_floaterm = true,

        floaterm = {
            posititon = 'bottom',
            height = 0.25,
            title_colors = 'nord',
        },
    },

    keys = {
        { "<leader>gtfu", "<cmd>GoTestFunc<cr>", desc = "Test Go Function", mode = { "n" }, },
        { "<leader>gtf", "<cmd>GoTestFunc<cr>", desc = "Test Go Function", mode = { "n" }, },
    },

    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()'
}
