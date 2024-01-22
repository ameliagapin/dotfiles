require("neo-tree").setup {
    enable_git_status = true,
    use_popups_for_input = true,
    window = {
        position = "left",
        width = 30,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
    },
      default_component_configs = {
        diagnostics = {
          symbols = {
            hint = "",
            info = "",
            warn = "",
            error = "✘",
          },
        },
    },
    event_handlers = {
        {
            event = "file_opened",
            handler = function(file_path)
                -- auto close
                -- vimc.cmd("Neotree close")
                -- OR
                require("neo-tree.command").execute({ action = "close" })
            end
        },
    },
}
