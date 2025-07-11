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
        opts = {
            inlay_hints = {
                enabled = true,
            },
        },
        config = function()
            -- https://github.com/nvim-lua/kickstart.nvim/blob/7af594fd319fbae6b2aaa06337f3df8acbbb7f18/init.lua#L580C1-L629C2
            -- More Servers:
            -- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
            local servers = {
                buf_ls = {},
                yamlls = {
                    filetypes = { 'yaml', 'yml' },
                    yaml = {
                        hover = true,
                        format = {
                            enable = true,
                        },
                        completion = true,
                        validate = true,
                        customTags = {
                            "!reference sequence",
                        },
                    },
                },
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        -- Disable the annoying warning for vim not being a defined global
                        diagnostics = { disable = { 'undefiled-global' } },
                    },
                },
                gopls = {
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
                },
                ts_ls = {},
                pyright = {},
                marksman = {},
                bashls = {
                    filetypes = { 'sh', 'bash' },
                },
                rust_analyzer = {},
                golangci_lint_ls = {
                    init_options = (function()
                        local pipe = io.popen("golangci-lint version|cut -d' ' -f4")
                        if pipe == nil then
                            return {}
                        end
                        local version = pipe:read("*a")
                        pipe:close()
                        local major_version = tonumber(version:match("^v?(%d+)%."))
                        if major_version and major_version > 1 then
                            return { command = { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false", "--issues-exit-code=1" } }
                        else
                            return { command = { "golangci-lint", "run", "--out-format", "json", "--show-stats=false", "--issues-exit-code=1" } }
                        end
                        return {}
                    end)(),
                }
            }

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- Ensure the servers above are installed
            local mason_lspconfig = require 'mason-lspconfig'

            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
                automatic_installation = true,
                handlers = servers,
            }

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),

                vim.diagnostic.config({
                    -- To enable virtual_text, comment this line out and uncomment the block below it
                    virtual_text = false,
                    -- virtual_text = {
                    --     -- source = "always",  -- Or "if_many"
                    --     prefix = '●', -- Could be '■', '▎', 'x'
                    --     severity = { min = vim.diagnostic.severity.ERROR }
                    -- },
                    underline = true,
                    severity_sort = true,
                    float = {
                        source = "always",
                    },
                    signs = {
                        severity = { min = vim.diagnostic.severity.WARN },
                        numhl = {
                            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                        },
                        text = {
                            [vim.diagnostic.severity.ERROR] = "✘ ",
                            [vim.diagnostic.severity.WARN] = "! ",
                            [vim.diagnostic.severity.INFO] = " ",
                            [vim.diagnostic.severity.HINT] = "",
                        },
                    },
                  }),

                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    client.server_capabilities.semanticTokensProvider = nil

                    -- This is needed to get formatting with yamlls
                    -- see: https://github.com/redhat-developer/yaml-language-server/issues/486
                    -- see: https://www.reddit.com/r/neovim/comments/197t7my/question_how_to_configure_yamlls_formatter_with/
                    if client.name == "yamlls" then
                        client.server_capabilities.documentFormattingProvider = true
                    end

                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, opts) -- Commented out because this is now default
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<C-h>', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)

                    vim.keymap.set('n', '<C-i>', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end)
                end,
            })

            -- Keep track of the last line and float status
            vim.b.last_line = -1
            -- If this is set to true, that means the float was dismissed by <Esc><Esc> as defined in keymap.lua
            -- It will get set back to false if the cursor moves to another line
            vim.b.float_dismissed = false

            function OpenDiagnosticIfNoFloat()
                local current_line = vim.fn.line(".")
                if vim.b.float_dismissed and current_line == vim.b.last_line then
                    return
                end

                vim.b.float_dismissed = false
                vim.b.last_line = current_line

                -- THIS IS FOR BUILTIN LSP
                vim.diagnostic.open_float(0, {
                    scope = "line",
                    focusable = false,
                    header = "Your fuckups:",
                    close_events = {
                        "CursorMoved",
                        "CursorMovedI",
                        "BufHidden",
                        "InsertCharPre",
                        "WinLeave",
                    },
                })
            end

            -- Show diagnostics under the cursor when holding position
            vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold" }, {
                pattern = "*",
                command = "lua OpenDiagnosticIfNoFloat()",
                group = "lsp_diagnostics_hold",
            })
        end
    },
}
