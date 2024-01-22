vim.keymap.set('n', '<Esc><Esc>', ':noh<CR><CR>') -- Clear previous search highlighing with ESC ESC
vim.keymap.set('n', '<C-j>', '<Cmd>bnext<CR>', { silent = true }) -- Next buffer
vim.keymap.set('n', '<C-k>', '<Cmd>bprevious<CR>', { silent = true }) -- Prev buffer
vim.keymap.set('n', '00', '^') -- Use 00 to go to the first non-whitespace char on line
vim.keymap.set('n', '<leader>t', '<Cmd>TroubleToggle document_diagnostics<CR>')
vim.keymap.set('n', '<leader>tw', '<Cmd>TroubleToggle workspace_diagnostics<CR>')
