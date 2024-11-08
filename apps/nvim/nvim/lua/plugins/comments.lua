return
{
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        keywords = {
            FIX = {
                icon = " ", -- icon used for the sign, and in search results
                color = "fix", -- can be a hex color, or a named color (see below)
                alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                -- signs = false, -- configure signs for some keywords individually
            },
            -- TODO = { icon = "", color = "todo" },
            TODO = { icon = "", color = "#939ede" },
            HACK = { icon = " ", color = "todo" },
            WARN = { icon = " ", color = "todo", alt = { "WARNING", "XXX" } },
            PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "todo", alt = { "INFO" } },
            TEST = { icon = "⏲ ", color = "todo", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        gui_style = {
            fg = "BOLD", -- The gui style to use for the fg highlight group.
            bg = "NONE", -- The gui style to use for the bg highlight group.
        },
        highlight = {
            keyword = "wide_fg",
            after = ""
        },
        colors = {
            fix = { "Property" },
            todo = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        },

    }
}
