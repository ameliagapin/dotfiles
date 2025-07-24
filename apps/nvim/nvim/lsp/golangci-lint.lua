return {
     cmd = { 'golangci-lint-langserver' },
    -- cmd = (function()
    --     local pipe = io.popen("golangci-lint version|cut -d' ' -f4")
    --     if pipe == nil then
    --         return {}
    --     end
    --     local version = pipe:read("*a")
    --     pipe:close()
    --     local major_version = tonumber(version:match("^v?(%d+)%."))
    --     if major_version and major_version < 2 then
    --         return { "golangci-lint", "run", "--out-format", "json", "--show-stats=false", "--issues-exit-code=1" }
    --     end
    --     return { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false", "--issues-exit-code=1" }
    -- end)(),
    -- cmd = { "golangci-lint", "run", "--out-format", "json", "--show-stats=false", "--issues-exit-code=1" },
    init_options = {
        command = (function()
            local pipe = io.popen("golangci-lint version|cut -d' ' -f4")
            if pipe == nil then
                return {}
            end
            local version = pipe:read("*a")
            pipe:close()
            local major_version = tonumber(version:match("^v?(%d+)%."))
            if major_version and major_version < 2 then
                return { "golangci-lint", "run", "--out-format", "json", "--show-stats=false", "--issues-exit-code=1" }
            end
            return { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false", "--issues-exit-code=1" }
        end)(),
    },
    filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
    root_markers = {
        ".golangci.yml",
        ".golangci.yaml",
        ".golangci.toml",
        ".golangci.json",
        "go.work",
        "go.mod",
        ".git",
    },
}
