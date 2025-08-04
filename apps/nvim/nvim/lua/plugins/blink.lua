return {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
        'rafamadriz/friendly-snippets',
        { "giuxtaposition/blink-cmp-copilot", },
    },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = 'default',

            -- ['<C-space>'] = { 'select_and_accept' },
            -- ['<Tab>'] = { 'select_and_accept', },
            ['<C-k>'] = { 'select_prev', 'fallback' },
            ['<C-j>'] = { 'select_next', 'fallback' },
            ['<Tab>'] = { 'hide' },
            -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
            -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
            ['<C-h>'] = { 'show_signature', 'hide_signature', 'fallback' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-space>'] = { 'show', 'select_and_accept' },
        },

        appearance = {
            nerd_font_variant = 'mono'
        },

        completion = {
            documentation = { auto_show = true },

            menu = {
                auto_show = true, -- Automatically show the menu when typing

                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label",      "label_description", gap = 1 },
                        { "kind" },
                        { "source_name" },
                    },
                },

                direction_priority = function()
                    local ctx = require('blink.cmp').get_context()
                    local item = require('blink.cmp').get_selected_item()
                    if ctx == nil or item == nil then
                        return { 's', 'n' }
                    end

                    local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
                    local is_multi_line = item_text:find('\n') ~= nil

                    -- after showing the menu upwards, we want to maintain that direction
                    -- until we re-open the menu, so store the context id in a global variable
                    if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                        vim.g.blink_cmp_upwards_ctx_id = ctx.id
                        return { 'n', 's' }
                    end
                    return { 's', 'n' }
                end,
            },

            ghost_text = {
                enabled = true,
                show_with_selection = true, -- Show ghost text when an item is selected
            },

            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                }
            },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = {
                'lsp',
                'copilot',
                'path',
                'buffer',
            },
            providers = {
                copilot = {
                    name = 'copilot',
                    module = 'blink-cmp-copilot',
                    score_offset = 100,
                    async = true,
                },
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = {
            implementation = "prefer_rust_with_warning",
            sorts = {
                'exact',
                'score',
                'sort_text'
            },
        },
        signature = { enabled = true }
    },
    opts_extend = { "sources.default" }
}
