--- Highlight, edit, and navigate code

local M = {
  'nvim-treesitter/nvim-treesitter',

  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
}

-- exposed so ./dots (steps/60-nvim.zsh) can install the same list headlessly
M.parsers = {
  'bash',
  'c',
  'comment',
  'css',
  'csv',
  'diff',
  'dockerfile',
  'gitignore',
  'go',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'nginx',
  'php',
  'python',
  'query',
  'regex',
  'rust',
  'scss',
  'svelte',
  'sql',
  'templ',
  'toml',
  'tsv',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  'zig',
}

M.config = function()
  require('nvim-treesitter').install(M.parsers)

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then
        return
      end

      -- check if parser exists and load it
      if not vim.treesitter.language.add(language) then
        return
      end

      -- enables syntax highlighting and other treesitter features
      vim.treesitter.start(buf, language)

      -- enables treesitter based indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

return M
