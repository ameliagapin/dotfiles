return {
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
        config = function()
            -- Setup language servers.
            local lspconfig = require('lspconfig')
            lspconfig.pyright.setup {}
            lspconfig.tsserver.setup {}
            lspconfig.gopls.setup {
                settings = {
                    analyses = {
                        nilness = true,
                        unusedparams = true,
                        unusedwrite = true,
                        useany = true
                    },
                    experimentalPostfixCompletions = true,
                    gofumpt = true,
                    usePlaceholders = true,
                    completeUnimported = true,
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true
                    },
                },
            }
            lspconfig.lua_ls.setup {}
            lspconfig.rust_analyzer.setup {}



            -- local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
            local signs = { Error = "✘ ", Warn = "! ", Hint = "", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),

                vim.diagnostic.config({
                    virtual_text = {
                        -- source = "always",  -- Or "if_many"
                        prefix = '●', -- Could be '■', '▎', 'x'
                        severity = { min = vim.diagnostic.severity.ERROR }
                    },
                    severity_sort = true,
                    float = {
                        source = "always", -- Or "if_many"
                    },
                    signs = {
                        severity = { min = vim.diagnostic.severity.WARN }
                    },
                }),


                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    client.server_capabilities.semanticTokensProvider = nil
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-i>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('i', '<C-i>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end,
            })
        end
    },
}
