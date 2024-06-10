return {
    {
        'github/copilot.vim',
        setup = function()
            -- vim.keymap.set('i', '<C-Space>', 'copilot#Accept("\\<CR>")', {
            --     expr = true,
            --     replace_keycodes = false
            -- })
            vim.api.nvim_set_keymap('i', '<expr>', '<Plug>(vimrc:copilot-dummy-map)', 'copilot#Accept("\t")',
                { silent = true })
            vim.g.copilot_no_tab_map = true
        end,
    },
}
