vim.keymap.set('n', '<Esc><Esc>', ':noh<CR><CR>') -- Clear previous search highlighing with ESC ESC
vim.keymap.set('n', '<C-j>', '<Cmd>bnext<CR>', { silent = true }) -- Next buffer
vim.keymap.set('n', '<C-k>', '<Cmd>bprevious<CR>', { silent = true }) -- Prev buffer
vim.keymap.set('n', '00', '^') -- Use 00 to go to the first non-whitespace char on line
vim.keymap.set('n', '<C-w>', '<C-w><C-w>') -- Ctrl-w to toggle through windows

-- Git
vim.keymap.set('n', '<leader>gb', '<Cmd>Git blame<CR>')

-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>t', '<Cmd>TroubleToggle document_diagnostics<CR>')
vim.keymap.set('n', '<leader>tw', '<Cmd>TroubleToggle workspace_diagnostics<CR>')

