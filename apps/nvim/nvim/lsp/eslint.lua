return {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = {
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.cjs",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.json",
        ".eslintrc",
        "package.json",
        ".git",
    },
    settings = {
        validate = "on",
        useESLintClass = false,
        experimental = { useFlatConfig = true },
        run = "onType",
        format = false, -- prefer prettier for formatting
        workingDirectory = { mode = "auto" },
    },
    handlers = {
        -- ESLint sends a custom notification to apply all fixes
        ["eslint/openDoc"] = function(_, result)
            return {}
        end,
        ["eslint/confirmESLintExecution"] = function(_, result)
            return 4 -- approve
        end,
        ["eslint/probeFailed"] = function()
            vim.notify("ESLint probe failed", vim.log.levels.WARN)
            return {}
        end,
        ["eslint/noLibrary"] = function()
            vim.notify("ESLint library not found", vim.log.levels.WARN)
            return {}
        end,
    },
}
