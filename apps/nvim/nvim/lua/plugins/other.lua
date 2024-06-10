return {
    'rgroli/other.nvim',
    config = function()
        require("other-nvim").setup({
            mappings = {
                -- builtin mappings
                "golang",
                {
                    pattern = "/(.*)/.*.go$",
                    target = "/%1/*.go",
                    context = "package",
                },
                {
                    pattern = ".*/(.*).go$",
                    target = "**/%1.go",
                    context = "same name",
                    transformer = "noVendor",
                },
            },
            transformers = {
                -- defining a custom transformer
                lowercase = function(inputString)
                    return inputString:lower()
                end,
                noVendor = function(inputString)
                    if string.sub(inputString, 1, string.len("vendor")) == "vendor" then
                        return ""
                    end
                    return "XXXXXXXXXXXXXXXXXXXXXX"
                end,
            },
            -- Should the window show files which do not exist yet based on
            -- pattern matching. Selecting the files will create the file.
            showMissingFiles = false,

            style = {
                -- How the plugin paints its window borders
                -- Allowed values are none, single, double, rounded, solid and shadow
                border = "solid",

                -- Column seperator for the window
                seperator = "|",

                -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
                width = 0.7,

                -- min height in rows.
                -- when more columns are needed this value is extended automatically
                minHeight = 2
            },
        })

        vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>:Other<CR>", { noremap = true, silent = true })
    end,
}
