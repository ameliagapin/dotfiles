STEP_NAME="Neovim: update"
STEP_DESC="Update plugins, treesitter parsers and Mason packages to their latest versions"

source "$DOTS_DIR/lib/nvim.zsh"

step_run() {
    if ! has nvim; then
        err "nvim is not installed — run the homebrew step first"
        return 1
    fi
    nvm_load  # npm for Mason's npm-based packages
    nvim_headless_lua "update plugins, treesitter parsers and Mason packages" \
        "$NVIM_MASON_UPGRADE_LUA" \
        "+Lazy! update" \
        "+lua require('nvim-treesitter').update():wait(600000)" \
        "+MasonUpdate"

    if [[ -n $(git -C "$DOTS_DIR" status --porcelain -- apps/nvim/nvim/lazy-lock.json) ]]; then
        info "lazy-lock.json changed — commit it to pin the new versions:"
        git -C "$DOTS_DIR" --no-pager diff --stat -- apps/nvim/nvim/lazy-lock.json
    else
        ok "lazy-lock.json unchanged"
    fi
}
