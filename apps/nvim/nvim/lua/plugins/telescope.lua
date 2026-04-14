return {
    {
        'nvim-telescope/telescope.nvim',
        -- Use master and not main because this has a fix to make treesitter work in the preview
        branch = 'master',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
        keys = {
            { "<C-b>",      "<cmd>Telescope buffers<cr>",                                                            desc = "Show buffers in telescope" },
            { "<C-p>",      "<cmd>Telescope find_files<cr>",                                                                     desc = "Find files in telescope" },
            { "<leader>/",  "<cmd>Telescope live_grep hidden=true<cr>",                                              desc = "Find files in telescope" },
            { "<leader>//", ":Telescope live_grep hidden=true cwd=",                                                 desc = "Find files in path in telescope" },
            { "<leader>/d", function() require('telescope.builtin').live_grep({ cwd = vim.fn.expand('%:p:h') }) end, desc = "Live grep in buffer's directory" },
            { '<leader>/r', require('telescope.builtin').lsp_references, desc = "Find references in telescope" },
        },
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup {
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = { height = 0.95 },
                    path_display = { 'truncate' },
                    mappings = {
                        i = {
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                            ['<esc><esc>'] = actions.close,
                        },
                        n = {
                            ['<esc><esc>'] = actions.close,
                        },
                    },
                    file_ignore_patterns = {
                        'node_modules',
                        '.git',
                        '.cache',
                        '.next',
                        'dist',
                        'build',
                        'target',
                        '__pycache__',
                        '*.lock',
                        '.claude/worktrees',
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = true,
                    },
                    grep_string = {
                        additional_args = function(opts)
                            return {
                                "--hidden",
                                "--no-ignore",
                                "--glob",
                                '!{**/.git/*,**/node_modules/*}',
                            }
                        end
                    },
                    live_grep = {
                        additional_args = function(opts)
                            return {
                                "--hidden",
                                "--no-ignore",
                                "--glob",
                                '!{**/.git/*,**/node_modules/*}',
                            }
                        end
                    },
                },
            }
            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')
            local builtin = require('telescope.builtin')
        end
    },
}
