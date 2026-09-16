return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- Must match nvim-treesitter's branch. `master` is frozen and requires the
    -- old `nvim-treesitter.configs` module, which no longer exists on `main`.
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('nvim-treesitter-textobjects').setup {
            select = {
                lookahead = true,
            },
            move = {
                set_jumps = true,
            },
        }

        -- On the `main` branch keymaps are no longer declared in setup();
        -- these are the same mappings as before, expressed the new way.
        local select = require('nvim-treesitter-textobjects.select')
        local move = require('nvim-treesitter-textobjects.move')
        local swap = require('nvim-treesitter-textobjects.swap')

        local function map(modes, lhs, fn, desc)
            vim.keymap.set(modes, lhs, fn, { desc = desc })
        end

        -- select
        local selects = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
        }
        for lhs, query in pairs(selects) do
            map({ 'x', 'o' }, lhs, function()
                select.select_textobject(query, 'textobjects')
            end, 'Select ' .. query)
        end

        -- move
        map({ 'n', 'x', 'o' }, ']]', function()
            move.goto_next_start('@function.outer', 'textobjects')
        end, 'Next function start')
        map({ 'n', 'x', 'o' }, '][', function()
            move.goto_next_end('@function.outer', 'textobjects')
        end, 'Next function end')
        map({ 'n', 'x', 'o' }, '[[', function()
            move.goto_previous_start('@function.outer', 'textobjects')
        end, 'Previous function start')
        map({ 'n', 'x', 'o' }, '[]', function()
            move.goto_previous_end('@class.outer', 'textobjects')
        end, 'Previous class end')

        -- swap
        map('n', '<leader>a', function()
            swap.swap_next('@parameter.inner')
        end, 'Swap with next parameter')
        map('n', '<leader>A', function()
            swap.swap_previous('@parameter.inner')
        end, 'Swap with previous parameter')
    end
}
