-- return {
--     {
--         'github/copilot.vim',
--         setup = function()
--             -- vim.keymap.set('i', '<C-space>', 'copilot#Accept("\\<CR>")', {
--             --     expr = true,
--             --     replace_keycodes = false
--             -- })
--             vim.g.copilot_no_tab_map = true
--
--             require("copilot").setup({
--                 suggestion = { enabled = false },
--                 panel = { enabled = false },
--             })
--         end,
--     },
-- }

return {
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        cmd = { "Copilot", "CopilotSetup" },
        opts = {
            suggestion = {
                enabled = false, -- Disable the suggestion popup
            },
            panel = {
                enabled = false, -- Disable the panel
            },
            -- keymap = {
            --     accept = "<C-l>",  -- Accept suggestion with Ctrl + l
            --     next = "<C-j>",    -- Navigate to next suggestion with Ctrl + j
            --     prev = "<C-k>",    -- Navigate to previous suggestion with Ctrl + k
            --     dismiss = "<C-e>", -- Dismiss the suggestion with Ctrl + e
            -- },
        },
    },
}
