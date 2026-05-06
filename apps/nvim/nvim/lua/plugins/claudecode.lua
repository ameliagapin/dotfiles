return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
        { "<leader>a",  nil,                              desc = "AI/Claude Code" },
        { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
        {
            "<leader>as",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        },
        -- Diff management
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
    opts = {
        terminal = {
            split_side = "left",
            snacks_win_opts = {
                position = "bottom",
                height = 0.4,
                width = 1.0,
                border = "rounded",
                title = " Claude ",
                title_pos = "center",
            }
        },
        diff_opts = {
            layout = "horizontal",   -- "vertical" or "horizontal"
            open_in_new_tab = false,
            keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
            hide_terminal_in_new_tab = false,
            -- on_new_file_reject = "keep_empty", -- "keep_empty" or "close_window"

            -- Legacy aliases (still supported):
            -- vertical_split = true,
            -- open_in_current_tab = true,
        },
    },
}
