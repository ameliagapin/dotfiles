return {

    'akinsho/bufferline.nvim',
    after = "catppuccin",
    version = "*",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        local bufferline = require('bufferline')

        require("bufferline").setup {
            options = {
                indicator = {
                    style = 'none',
                },
                style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
                show_buffer_close_icons = false,
                show_close_icon = false,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    if level:match("error") then
                        return " ✘ "
                    end
                    return ""
                end,
                numbers = "id",
                show_buffer_icons = false, -- disable filetype icons for buffers
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        text_align = "left",
                        separator = true
                    }
                },
            },
            highlights = {
                pick = {
                    fg = '#c792ea',
                },
                pick_selected = {
                    fg = '#c792ea',
                },
                numbers = {
                    fg = '#c792ea',
                },
                numbers_visible = {
                    fg = '#c792ea',
                },
                numbers_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                modified = {
                    fg = '#c792ea',
                },
                modified_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                buffer = {
                    fg = '#c792ea',
                },
                hint = {
                    fg = '#c792ea',
                },
                error = {
                    fg = '#c792ea',
                },
                info = {
                    fg = '#c792ea',
                },
                warning = {
                    fg = '#c792ea',
                },
                background = {
                    fg = '#c792ea',
                },
                duplicate = {
                    fg = '#c792ea',
                },
                duplicate_visible = {
                    fg = '#c792ea',
                },
                duplicate_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                diagnostic = {
                    fg = '#c792ea',
                },
                modified_visible = {
                    fg = '#c792ea',
                },
                buffer_visible = {
                    fg = '#c792ea',
                },
                hint_visible = {
                    fg = '#c792ea',
                },
                hint_diagnostic_visible = {
                    fg = '#c792ea',
                },
                error_visible = {
                    fg = '#c792ea',
                },
                error_diagnostic_visible = {
                    -- fg = '#c792ea',
                    fg = '#ff5370',
                },
                error_diagnostic = {
                    -- fg = '#c792ea',
                    fg = '#ff5370',
                },
                info_visible = {
                    fg = '#c792ea',
                },
                info_diagnostic_visible = {
                    fg = '#c792ea',
                },
                warning_diagnostic_visible = {
                    fg = '#c792ea',
                },
                warning_visible = {
                    fg = '#c792ea',
                },
                diagnostic_visible = {
                    fg = '#c792ea',
                },
                buffer_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                hint_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                hint_diagnostic_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                error_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                error_diagnostic_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                info_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                info_diagnostic_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                warning_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                warning_diagnostic_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
                diagnostic_selected = {
                    bg = '#bfc7d5',
                    fg = '#1a1a1a',
                },
            },
        }
    end
}
