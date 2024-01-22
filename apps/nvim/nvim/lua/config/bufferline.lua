local bufferline = require('bufferline')
require("bufferline").setup {
    options = {
        indicator = {
            style = 'none',
        },
        style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if level:match("error") then
                return " ✘ " .. count
            end
            return ""
        end,
        numbers = "id",
        show_buffer_icons = false, -- disable filetype icons for buffers
        offsets = {
            {
                filetype = "NeoTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
            }
        },

    },
    highlights = {
        numbers_selected = {
            bold = false,
            italic = false,
        },
        buffer_visible = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        buffer_selected = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            italic = false,
            bold = false,
        },
        diagnostic = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        diagnostic_visible = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        diagnostic_selected = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        error = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        error_visible = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        error_selected = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        warning = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        warning_visible = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        warning_selected = {
            fg = { attribute = "fg", highlight = "text" },
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        info = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        info_visible = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        info_selected = {
            fg = { attribute = "fg", highlight = "text" },
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        hint = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        hint_visible = {
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },
        hint_selected = {
            fg = { attribute = "fg", highlight = "text" },
            guifg = { attribute = "fg", highlight = "TabLine" },
            guibg = { attribute = "bg", highlight = "TabLine" },
            bold = false,
            italic = false,
        },

    },
}
