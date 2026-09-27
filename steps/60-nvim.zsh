STEP_NAME="Neovim"
STEP_DESC="Link config, install plugins (lazy-lock.json), build treesitter parsers, install LSP servers"

source "$DOTS_DIR/lib/nvim.zsh"

step_run() {
    if ! has nvim; then
        err "nvim is not installed — run the homebrew step first"
        return 1
    fi
    link "$DOTS_DIR/apps/nvim/nvim" "$HOME/.config/nvim"
    # Mason installs several servers with npm, which comes from nvm here
    nvm_load
    if ! has npm; then
        warn "npm not found — npm-based LSP servers will fail to install (run the node step)"
    fi

    # One nvim session: lazy.nvim installs plugins to the lockfile, then the
    # Lua snippet waits for the treesitter parsers and Mason packages the
    # config asks for and verifies they're all there.
    nvim_headless_lua "install plugins, treesitter parsers and LSP servers" \
        "$NVIM_MASON_ENSURE_LUA" "+Lazy! restore"
}
