local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95 },
        mappings = {
            i = {
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
                ['<esc><esc>'] = actions.close,

            },
        },
    },
}
--
--
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
