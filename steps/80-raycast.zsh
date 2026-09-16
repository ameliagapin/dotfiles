STEP_NAME="Raycast"
STEP_DESC="Link ~/.raycast-scripts (add it as a script directory in Raycast)"

step_run() {
    link "$DOTS_DIR/apps/raycast/scripts" "$HOME/.raycast-scripts"
}
