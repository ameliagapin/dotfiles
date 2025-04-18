return {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Lazy is not recommended

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("markview").setup({
            preview = {
                enable = false,

                splitview_winopts = {
                    split = "below",
                },

                callbacks = {
                    on_enable = function(split_buf, split_win)
                        vim.wo.wrap = true
                        vim.wo.linebreak = true
                        vim.api.nvim_win_set_option(split_win, "wrap", true)
                        vim.api.nvim_win_set_option(split_win, "linebreak", true)

                        vim.api.nvim_buf_set_keymap(split_buf, 'n', 'j', 'gj', { noremap = true, silent = true })
                        vim.api.nvim_buf_set_keymap(split_buf, 'n', 'k', 'gk', { noremap = true, silent = true })
                        vim.api.nvim_win_set_keymap(split_win, 'n', 'j', 'gj', { noremap = true, silent = true })
                        vim.api.nvim_win_set_keymap(split_win, 'n', 'k', 'gk', { noremap = true, silent = true })
                    end,

                    on_disable = function(split_buf, split_win)
                        vim.wo.wrap = false
                        vim.wo.linebreak = false
                        vim.api.nvim_win_set_option(split_win, "wrap", false)
                        vim.api.nvim_win_set_option(split_win, "linebreak", false)
                        vim.api.nvim_buf_set_option(split_buf, "wrap", false)
                        vim.api.nvim_buf_set_option(split_buf, "linebreak", true)
                    end,

                    on_splitview_open = function(_, split_buf, split_win)
                        vim.wo.wrap = true
                        vim.wo.linebreak = true
                        vim.api.nvim_win_set_option(split_win, "wrap", true)
                        vim.api.nvim_win_set_option(split_win, "linebreak", true)

                        vim.api.nvim_buf_set_keymap(split_buf, 'n', 'j', 'gj', { noremap = true, silent = true })
                        vim.api.nvim_buf_set_keymap(split_buf, 'n', 'k', 'gk', { noremap = true, silent = true })
                        vim.api.nvim_win_set_keymap(split_win, 'n', 'j', 'gj', { noremap = true, silent = true })
                        vim.api.nvim_win_set_keymap(split_win, 'n', 'k', 'gk', { noremap = true, silent = true })
                    end,

                    on_splitview_close = function(_, split_buf, split_win)
                        vim.wo.wrap = false
                        vim.wo.linebreak = false
                        vim.api.nvim_buf_set_option(split_buf, "wrap", false)
                        vim.api.nvim_buf_set_option(split_buf, "linebreak", true)
                        vim.api.nvim_win_set_option(split_win, "wrap", false)
                        vim.api.nvim_win_set_option(split_win, "linebreak", false)
                    end,

                },
            },
        })

        vim.api.nvim_set_keymap("n", "<leader>md", "<cmd>:Markview splitToggle<CR>", { noremap = true, silent = true })
    end,
}
