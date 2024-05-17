vim.keymap.set('n', '<C-j>', '<Cmd>bnext<CR>', { silent = true })     -- Next buffer
vim.keymap.set('n', '<C-k>', '<Cmd>bprevious<CR>', { silent = true }) -- Prev buffer
vim.keymap.set('n', '00', '^')                                        -- Use 00 to go to the first non-whitespace char on line
vim.keymap.set('n', '<C-w>', '<C-w><C-w>')                            -- Ctrl-w to toggle through windows

-- Git
vim.keymap.set('n', '<leader>gb', '<Cmd>Git blame<CR>')

-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev) -- Commented out because this is now default
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next) -- Commented out because this is now default
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>t', '<Cmd>TroubleToggle document_diagnostics<CR>')
vim.keymap.set('n', '<leader>tw', '<Cmd>TroubleToggle workspace_diagnostics<CR>')

-- Close all floating windows
-- except for telescope. Telescope is handled by adding a mapping in telescope.lua
local function close_floating()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
            vim.api.nvim_win_close(win, true) -- boolean means force close
        end
    end
end

vim.keymap.set('n', "<esc><esc>", function()
    close_floating()
    vim.cmd.noh() -- Clear previous search highlighing

    -- This line sets a boolean that is used in lsp.lua to determine if the diagnostic float has been dismissed
    -- for the current line. It will be reset when the user moves lines
    vim.b.float_dismissed = true
end)
