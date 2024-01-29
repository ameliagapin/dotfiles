-- Open config
vim.api.nvim_create_user_command(
    'RC',
    'e ~/.config/nvim/lua/config/init.lua',
    { bang = true }
)

-- Writing mode
vim.api.nvim_create_user_command(
    'WR',
    function()
        vim.wo.wrap = true
        vim.wo.linebreak = true

        -- Move by display line instead of physical line when lines are wrapped
        vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', { noremap = true, silent = true })
    end,
    { bang = true, desc = 'Writing mode' }
)

-- Close all buffers except current
vim.api.nvim_create_user_command(
    'Bonly',
    ':%bd|e#',
    { bang = true, desc = 'Close all buffers except current' }
)
