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
            { "<C-n>", "<cmd>Neotree toggle<cr>",            desc = "NeoTree" },
            { "<C-f>", "<cmd>Neotree filesystem reveal<cr>", desc = "NeoTree" },
        },
        config = function(_, opts)
            require("neo-tree").setup {
                enable_git_status = true,
                use_popups_for_input = true,
                window = {
                    position = "left",
                    width = 30,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                },
                default_component_configs = {
                    diagnostics = {
                        symbols = {
                            hint = "",
                            info = "",
                            warn = "",
                            error = "✘",
                        },
                    },
                },
                event_handlers = {
                    {
                        event = "file_opened",
                        handler = function(file_path)
                            -- auto close
                            -- vimc.cmd("Neotree close")
                            -- OR
                            require("neo-tree.command").execute({ action = "close" })
                        end
                    },
                },
            }
        end,
    },
}
