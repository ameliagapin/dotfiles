return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        keys = {
            { "<C-n>",     "<cmd>Neotree toggle<cr>",                  desc = "NeoTree" },
            { "<C-f>",     "<cmd>Neotree filesystem reveal<cr>",       desc = "NeoTree" },
            { "<leader>b", "<cmd>Neotree toggle buffers<cr>",          desc = "Buffers" },
            { "<leader>d", "<cmd>Neotree toggle diagnostics<cr>",      desc = "Diagnostics" },
            { "<C-s>",     "<cmd>Neotree toggle document_symbols<cr>", desc = "Symbols" },
        },
        config = function(_, opts)
            require("neo-tree").setup {
                enable_git_status = true,
                use_popups_for_input = true,
                window = {
                    position = "left",
                    width = 40,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                },
                filesystem = {
                    window = {
                        mappings = {
                            -- open file in system editor
                            ["o"] = "system_open",
                            -- use p to go up a level
                            ["p"] = function(state)
                                local node = state.tree:get_node()
                                require 'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
                            end,
                            -- disable fuzzy finder
                            ["/"] = "noop"
                        },
                    },
                    commands = {
                        system_open = function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.jobstart({ "open", path }, { detach = true })
                        end,
                    },
                },
                document_symbols = {
                    renderers = {
                        root = {
                            { "indent" },
                            { "icon", default = "★ " },
                            { "name", zindex = 10 },
                        },
                    },
                    window = {
                        mappings = {
                            ["o"] = "open",
                            ["<cr>"] = "open",
                            ["l"] = "open",
                            ["<2-LeftMouse>"] = "open",
                            ["<esc>"] = "close_all_nodes",
                        },
                    },
                },
                diagnostics = {
                    auto_preview = {                     -- May also be set to `true` or `false`
                        enabled = false,                 -- Whether to automatically enable preview mode
                        preview_config = {},             -- Config table to pass to auto preview (for example `{ use_float = true }`)
                        event = "neo_tree_buffer_enter", -- The event to enable auto preview upon (for example `"neo_tree_window_after_open"`)
                    },
                    bind_to_cwd = true,
                    diag_sort_function = "severity", -- "severity" means diagnostic items are sorted by severity in addition to their positions.
                    -- "position" means diagnostic items are sorted strictly by their positions.
                    -- May also be a function.
                    follow_current_file = {               -- May also be set to `true` or `false`
                        enabled = true,                   -- This will find and focus the file in the active buffer every time
                        always_focus_file = false,        -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file
                        expand_followed = true,           -- Ensure the node of the followed file is expanded
                        leave_dirs_open = false,          -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                        leave_files_open = false,         -- `false` closes auto expanded files, such as with `:Neotree reveal`
                    },
                    group_dirs_and_files = true,          -- when true, empty folders and files will be grouped together
                    group_empty_dirs = true,              -- when true, empty directories will be grouped together
                    show_unloaded = true,                 -- show diagnostics from unloaded buffers
                    refresh = {
                        delay = 100,                      -- Time (in ms) to wait before updating diagnostics. Might resolve some issues with Neovim hanging.
                        event = "vim_diagnostic_changed", -- Event to use for updating diagnostics (for example `"neo_tree_buffer_enter"`)
                        -- Set to `false` or `"none"` to disable automatic refreshing
                        max_items = 10000,                -- The maximum number of diagnostic items to attempt processing
                        -- Set to `false` for no maximum
                    },
                },
                default_component_configs = {
                    diagnostics = {
                        symbols = {
                            hint = " ",
                            info = " ",
                            warn = "! ",
                            error = "✘ ",
                        },
                    },
                    git_status = {
                        symbols = {
                            -- Change type
                            added     = "✚", -- NOTE: you can set any of these to an empty string to not show them
                            deleted   = "✖",
                            modified  = "",
                            renamed   = "󰁕",
                            -- Status type
                            untracked = "",
                            ignored   = "",
                            unstaged  = "󰄱",
                            staged    = "",
                            conflict  = "",
                        },
                        align = "right",
                    },
                },
                event_handlers = {
                    {
                        event = "file_opened",
                        handler = function(file_path)
                            require("neo-tree.command").execute({ action = "close" })
                        end
                    },
                },
                sources = {
                    "filesystem",
                    "buffers",
                    "git_status",
                    "document_symbols",
                    "diagnostics",
                },
            }
        end,
    },
}
