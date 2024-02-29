vim.opt.updatetime = 100
vim.opt.timeoutlen = 500
vim.opt.scrolloff = 3 -- start scrolling 3 lines before top/bottom
vim.o.mouse = 'a'     -- enable mouse mode

vim.opt.swapfile = false

-- Clipboard
vim.opt.clipboard = "unnamed"

-- Undo file
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Indent Settings
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.wildignore:append({ '*.DS_Store' })

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Strip whitespace on save and restore cursor position
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function(ev)
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})
