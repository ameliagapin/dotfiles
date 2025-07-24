return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
    root_markers = { "go.mod", "go.work", ".git" },
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
