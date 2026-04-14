return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            use_diagnostic_signs = true,
            severity = vim.diagnostic.severity.WARN,
        },
        keys = {
            {
                "<leader>ta",
                "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>tb",
                "<cmd>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
}
