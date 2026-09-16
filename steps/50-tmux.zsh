STEP_NAME="tmux"
STEP_DESC="Link ~/.tmux.conf"

step_run() {
    # the old install linked a misspelled ~/.tmux.confg that tmux never read
    if [[ -L $HOME/.tmux.confg ]]; then
        rm "$HOME/.tmux.confg"
        info "removed stale ~/.tmux.confg symlink"
    fi
    link "$DOTS_DIR/apps/tmux/tmux.conf" "$HOME/.tmux.conf"
}
