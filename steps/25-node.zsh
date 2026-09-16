STEP_NAME="Node (nvm)"
STEP_DESC="Install the latest LTS Node with nvm if none is installed, and make it the default"

step_run() {
    if ! has brew || [[ ! -s $(brew --prefix nvm 2> /dev/null)/nvm.sh ]]; then
        err "nvm is not installed — run the homebrew step first"
        return 1
    fi
    mkdir -p "$HOME/.nvm"
    nvm_load
    local current
    current=$(nvm version default 2> /dev/null || true)
    if [[ -n $current && $current != N/A ]]; then
        ok "node $current is nvm's default ($(command -v node))"
    else
        info "no node installed in nvm — installing the latest LTS"
        set +e
        nvm install --lts
        local rc=$?
        set -e
        (( rc == 0 )) || return $rc
        nvm alias default 'lts/*' > /dev/null
        ok "node $(nvm version default) installed and set as default"
    fi
}
