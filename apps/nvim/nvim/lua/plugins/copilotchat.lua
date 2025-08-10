return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken",
        config = function()
            require("CopilotChat").setup {
                model = 'gpt-5', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).

                window = {
                    layout = 'horizontal', -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
                    -- width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
                    height = 0.40, -- fractional height of parent, or absolute height in rows when > 1
                    -- Options below only apply to floating windows
                    relative = 'editor',    -- 'editor', 'win', 'cursor', 'mouse'
                    border = 'single',      -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
                    title = 'Copilot Chat', -- title of chat window
                    zindex = 1,             -- determines if window is on top or below other floating windows
                },
                mappings = {
                    submit_prompt = {
                        normal = '<leader>s',
                        insert = '<C-s>'
                    },
                    show_diff = {
                        full_diff = true
                    }
                }
            }

            vim.keymap.set('n', '<leader>cc', '<Cmd>CopilotChatToggle<CR>')
            vim.keymap.set('n', '<leader>cr', '<Cmd>CopilotChatReset<CR>')
        end,
    },
}
