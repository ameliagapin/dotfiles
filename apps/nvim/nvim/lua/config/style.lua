vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.wo.number = true
vim.opt.showmode = false -- Hide --INSERT-- from status line
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = {
    --     eol = '↵',
    trail = '·',
    space = '·',
    tab = '→ ',
    --     -- tab = '| ',
}
vim.opt.cursorline = true -- highlight current line
vim.opt.colorcolumn = '80,120'

require("catppuccin").setup({
    flavour = "mocha",           -- latte, frappe, macchiato, mocha
    show_end_of_buffer = false,  -- shows the '~' characters after the end of buffers
    dim_inactive = {
        enabled = true,          -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.35,       -- percentage of the shade to apply to the inactive window
    },
    no_italic = false,           -- Force no italic
    no_bold = false,             -- Force no bold
    no_underline = false,        -- Force no underline
    styles = {                   -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    term_colors = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
        notify = false,
        lsp_trouble = false,
        telescope = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
    highlight_overrides = {
        mocha = function(mocha)
            return {
                Function = { fg = mocha.yellow },
                Property = { fg = mocha.red },
                ["@property"] = { fg = mocha.red },
                ["@variable"] = { fg = mocha.text },
                ["@parameter"] = { fg = mocha.text },
                ["@namespace"] = { fg = mocha.text },
                ["@function.builtin"] = { fg = mocha.red },
                ["@constant"] = { fg = mocha.text },
                ["@constant.builtin"] = { fg = mocha.lavender },
                Type = { fg = mocha.yellow },
                -- ["@type"] = { fg = mocha.yellow },
                ["@type.builtin"] = { fg = mocha.yellow },
                NeoTreeDirectoryName = { fg = mocha.purple },
                NeoTreeDirectoryIcon = { fg = mocha.red },
                NeoTreeRootName = { fg = mocha.purple },
                NeoTreeRootIcon = { fg = mocha.purple },
                NeoTreeFileName = { fg = mocha.green },
                NeoTreeTabActive = { fg = mocha.text, bg = mocha.base },
                NeoTreeTabInactive = { fg = mocha.surface2, bg = mocha.base },
            }
        end,
    },
    color_overrides = {
        mocha = {
            base = "#1a1a1a",
            mantle = "#1a1a1a",
            crust = "#1a1a1a",
            green = "#C3E88D",
            red = "#ff5370",
            pink = "#ff869a",
            yellow = "#ffcb6b",
            blue = "#82b1ff",
            sky = "#89ddff",
            lavender = "#939ede",
            purple = "#c792ea",
            text = "#bfc7d5",
        },
    },
})

--
vim.cmd.colorscheme "catppuccin"


-- use TSRainbow colors to match rainbow colors from nvim-ts-rainbow2
local highlight = {
    "TSRainbowRed",
    "TSRainbowYellow",
    "TSRainbowBlue",
    "TSRainbowOrange",
    "TSRainbowGreen",
    "TSRainbowViolet",
    "TSRainbowCyan",
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
