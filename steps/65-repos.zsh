STEP_NAME="repos"
STEP_DESC="Pick repos from your GitHub (via gh) and clone them into ~/Projects; existing ones are skipped"

step_run() {
    local dir=${PROJECTS_DIR:-$HOME/Projects} me=ameliagapin

    local tool
    for tool in gh fzf; do
        if ! has $tool; then
            err "$tool is not installed — run the homebrew step first"
            return 1
        fi
    done
    if [[ ! -t 0 || ! -t 1 ]]; then
        err "picking repos needs an interactive terminal"
        return 1
    fi
    if ! gh auth status > /dev/null 2>&1; then
        err "gh is not logged in — run: gh auth login"
        return 1
    fi

    info "fetching the repos you can access"
    local repos
    repos=$(gh api --paginate 'user/repos?affiliation=owner,collaborator,organization_member&per_page=100' \
        --jq '.[] | [.owner.login, .name, (.private | tostring), (.fork | tostring), (.archived | tostring)] | @tsv')
    if [[ -z $repos ]]; then
        warn "no repos found"
        return 0
    fi

    # One line per repo: owner<TAB>name<TAB>label, with a header line (empty
    # name) opening each owner's group. Mine sorts first, the rest by name.
    local tab=$'\t' menu
    menu=$(print -r -- "$repos" \
        | awk -F'\t' -v me="$me" '{ print (tolower($1) == tolower(me) ? 0 : 1) "\t" tolower($1) "\t" $0 }' \
        | sort -t "$tab" -k1,1n -k2,2 -k4,4f \
        | awk -F'\t' '
            $3 != last { last = $3; print $3 "\t\t── " $3 " ──" }
            {
                flags = ""
                if ($5 == "true") flags = flags " [private]"
                if ($6 == "true") flags = flags " [fork]"
                if ($7 == "true") flags = flags " [archived]"
                print $3 "\t" $4 "\t  " $3 "/" $4 flags
            }')

    local picked
    picked=$(print -r -- "$menu" | fzf --multi --no-sort --layout=reverse --height=90% \
        --delimiter "$tab" --with-nth=3 \
        --header 'Tab: select · Enter: clone selected · Esc: cancel' \
        --prompt 'repos> ' || true)

    local -a selected
    selected=(${(f)"$(print -r -- "$picked" | awk -F'\t' '$2 != "" { print $1 "/" $2 }')"})
    if (( ${#selected} == 0 )); then
        info "nothing selected"
        return 0
    fi

    mkdir -p "$dir"
    local slug name dest cloned=0 skipped=0 failed=0
    for slug in "${selected[@]}"; do
        name=${slug#*/}
        dest=$dir/$name
        if [[ -e $dest ]]; then
            ok "already exists, skipping: $dest"
            (( ++skipped ))
        elif run gh repo clone "$slug" "$dest"; then
            (( ++cloned ))
        else
            err "failed to clone $slug"
            (( ++failed ))
        fi
    done

    info "cloned $cloned, skipped $skipped, failed $failed"
    (( failed == 0 ))
}
