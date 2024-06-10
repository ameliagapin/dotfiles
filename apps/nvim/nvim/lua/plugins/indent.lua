return {
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
        opts = {},
        config = function()
            -- use TSRainbow colors to match rainbow colors from nvim-ts-rainbow2
            local highlight = {
                "RainbowDelimiterRed",
                "RainbowDelimiterYellow",
                "RainbowDelimiterBlue",
                "RainbowDelimiterOrange",
                "RainbowDelimiterGreen",
                "RainbowDelimiterViolet",
                "RainbowDelimiterCyan",
            }

            require("ibl").setup {
                scope = {
                    enabled = true,
                    show_start = false,
                    show_end = false,
                    highlight = highlight,
                    include = {
                        node_type = { ["*"] = { "*" } },
                    },
                },
                --
                indent = {
                    tab_char = { "|" },
                },
                whitespace = {
                    remove_blankline_trail = false,
                }
            }
            local hooks = require "ibl.hooks"
            hooks.register(
            -- tell ibl to use the eternal highlight colors. I don't know, it's in help docs
                hooks.type.SCOPE_HIGHLIGHT,
                hooks.builtin.scope_highlight_from_extmark
            )
        end
    },
}
