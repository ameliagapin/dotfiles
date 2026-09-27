# lib/ui.zsh — the interactive menu for ./dots. Sourced by ./dots, which
# provides STEP_IDS, STEP_DESC_OF, STEP_STATUS, run_step and run_many.

tui_cleanup() {
    tput cnorm 2> /dev/null
    tput rmcup 2> /dev/null
}

# Read one keypress and print a symbolic name. Times out after a second so
# the menu can redraw (e.g. after a terminal resize).
tui_read_key() {
    local k k2 k3
    if ! read -sk1 -t 1 k; then
        print -r -- tick
        return 0
    fi
    case $k in
        $'\e')
            # arrow keys arrive as ESC [ A/B; a bare Escape has no follow-up
            if read -sk1 -t 0.05 k2 && [[ $k2 == '[' ]] && read -sk1 -t 0.05 k3; then
                case $k3 in
                    A) print -r -- up ;;
                    B) print -r -- down ;;
                    *) print -r -- other ;;
                esac
            else
                print -r -- other
            fi ;;
        $'\r'|$'\n') print -r -- enter ;;
        j|J) print -r -- down ;;
        k|K) print -r -- up ;;
        a|A) print -r -- all ;;
        q|Q) print -r -- quit ;;
        *)   print -r -- other ;;
    esac
}

tui_draw() {
    local sel=$1 i id mark
    tput clear
    print -r -- "${_c_bold}dotfiles${_c_reset}  ${_c_dim}${DOTS_DIR}${_c_reset}"
    print -r -- "${_c_dim}↑/↓ or j/k to move · Enter to run · a to run all · q to quit${_c_reset}"
    print
    for (( i = 1; i <= ${#STEP_IDS}; i++ )); do
        id=${STEP_IDS[$i]}
        case ${STEP_STATUS[$id]:-0} in
            1) mark="${_c_ok}✓${_c_reset}" ;;
            2) mark="${_c_err}✗${_c_reset}" ;;
            *) mark=" " ;;
        esac
        if (( i == sel )); then
            print -r -- " ${_c_bold}›${_c_reset} $mark ${_c_bold}${(r:14:)id}${_c_reset} ${STEP_DESC_OF[$id]}"
        else
            print -r -- "   $mark ${(r:14:)id} ${_c_dim}${STEP_DESC_OF[$id]}${_c_reset}"
        fi
    done
}

tui_pause() {
    local k
    print
    print -n -- "${_c_dim}press any key to return to the menu${_c_reset}"
    read -sk1 k
    print
}

# Leave the menu screen while a step runs so its output stays in scrollback.
tui_run() {
    tput rmcup
    tput cnorm
    "$@"
    tui_pause
    tput smcup
    tput civis
}

tui_main() {
    if [[ ! -t 0 || ! -t 1 ]]; then
        err "the menu needs an interactive terminal (try: ./dots --list)"
        return 1
    fi
    local -i sel=1 n=${#STEP_IDS}
    local key
    trap 'tui_cleanup; exit 130' INT TERM
    trap 'tui_cleanup' EXIT
    tput smcup
    tput civis
    while true; do
        tui_draw $sel
        key=$(tui_read_key)
        case $key in
            up)    (( sel = sel <= 1 ? n : sel - 1 )) ;;
            down)  (( sel = sel >= n ? 1 : sel + 1 )) ;;
            enter) tui_run run_step "${STEP_IDS[$sel]}" ;;
            all)   tui_run run_many "${STEP_IDS[@]}" ;;
            quit)  break ;;
        esac
    done
    tui_cleanup
    trap - INT TERM EXIT
    return 0
}
