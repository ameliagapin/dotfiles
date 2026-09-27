# lib/core.zsh — helpers shared by ./dots and every step. Sourced, never executed.
#
# Steps run inside a subshell with `set -e -o pipefail`, so helpers return
# non-zero on failure and let the step abort. Nothing here uses `emulate -L`
# in a function that runs other commands: it would reset ERR_EXIT and swallow
# failures.

# ---------------------------------------------------------------- output ----

if [[ -t 1 ]]; then
    _c_bold=$'\e[1m' _c_dim=$'\e[2m' _c_reset=$'\e[0m'
    _c_info=$'\e[36m' _c_ok=$'\e[32m' _c_warn=$'\e[33m' _c_err=$'\e[31m'
else
    _c_bold= _c_dim= _c_reset= _c_info= _c_ok= _c_warn= _c_err=
fi

info() { print -r -- "${_c_info}·${_c_reset} $*" }
ok()   { print -r -- "${_c_ok}✓${_c_reset} $*" }
warn() { print -r -- "${_c_warn}!${_c_reset} $*" }
err()  { print -r -- "${_c_err}✗${_c_reset} $*" >&2 }

# Echo a command, then run it.
run() {
    print -r -- "${_c_dim}\$ $*${_c_reset}"
    "$@"
}

# ------------------------------------------------------------ predicates ----

# has <cmd> — true if <cmd> is an executable on PATH (not an alias/function).
has() { (( $+commands[$1] )) }

# confirm <question> — y/N prompt. Non-interactive sessions answer "no".
confirm() {
    local answer
    if [[ ! -t 0 ]]; then
        warn "not interactive, answering no: $1"
        return 1
    fi
    print -n -- "$1 [y/N] "
    read -k1 answer
    print
    [[ $answer == [yY] ]]
}

# require_sudo <why> — prime sudo once so later commands don't each prompt.
require_sudo() {
    sudo -n true 2>/dev/null && return 0
    info "sudo is needed to $1"
    sudo -v
}

# --------------------------------------------------------------- files ----

# link <src> <dest> — idempotent symlink.
#   already correct  → nothing
#   other symlink    → replaced
#   real file/dir    → moved to <dest>.bak first
link() {
    local src=$1 dest=$2
    if [[ ! -e $src ]]; then
        err "link: source does not exist: $src"
        return 1
    fi
    if [[ -L $dest ]]; then
        if [[ ${dest:A} == ${src:A} ]]; then
            ok "link ok: $dest"
            return 0
        fi
        info "replacing symlink $dest (was → $(readlink "$dest"))"
        rm "$dest"
    elif [[ -e $dest ]]; then
        local backup=$dest.bak
        [[ -e $backup ]] && backup=$dest.bak.$(date +%Y%m%d%H%M%S)
        warn "backing up existing $dest → $backup"
        mv "$dest" "$backup"
    fi
    mkdir -p "${dest:h}"
    ln -s "$src" "$dest"
    ok "linked: $dest → $src"
}

# ensure_line_in_file <line> <file> — append <line> unless it's already there.
# Uses sudo when the file isn't writable by the user (e.g. /etc/shells).
ensure_line_in_file() {
    local line=$1 file=$2
    if [[ -f $file ]] && grep -qxF -- "$line" "$file"; then
        return 0
    fi
    if [[ -w $file || ( ! -e $file && -w ${file:h} ) ]]; then
        print -r -- "$line" >> "$file"
    else
        require_sudo "append to $file"
        print -r -- "$line" | sudo tee -a "$file" > /dev/null
    fi
    ok "added to $file: $line"
}

# dedupe_file <file> — drop repeated non-blank lines, keeping the first.
dedupe_file() {
    local file=$1 tmp
    [[ -f $file ]] || return 0
    tmp=$(mktemp)
    awk 'NF == 0 || !seen[$0]++' "$file" > "$tmp"
    if cmp -s "$file" "$tmp"; then
        rm -f "$tmp"
        return 0
    fi
    cat "$tmp" > "$file"
    rm -f "$tmp"
    ok "removed duplicate lines from $file"
}

# clone_or_pull <url> <dest> — git clone the first time, fast-forward after.
clone_or_pull() {
    local url=$1 dest=$2
    if [[ -d $dest/.git ]]; then
        if git -C "$dest" pull --ff-only --quiet; then
            ok "updated: $dest"
        else
            warn "could not update $dest (offline or diverged) — leaving as is"
        fi
    else
        run git clone --quiet "$url" "$dest"
    fi
}

# ----------------------------------------------------------- environment ----

# prime_env — make Homebrew visible to this shell. Called by ./dots at startup
# and after every step, so a step that just installed brew is enough for the
# next one to use it.
prime_env() {
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    return 0
}

# nvm_load — put nvm's default node/npm on PATH for this shell, if nvm and a
# node version are installed. Quiet no-op otherwise.
nvm_load() {
    local nvm_sh had_errexit=0
    export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
    has brew || return 0
    nvm_sh=$(brew --prefix nvm 2> /dev/null)/nvm.sh
    [[ -s $nvm_sh ]] || return 0
    # nvm.sh isn't written for errexit
    [[ -o errexit ]] && had_errexit=1
    set +e
    source "$nvm_sh" --no-use
    nvm use default > /dev/null 2>&1
    (( had_errexit )) && set -e
    return 0
}
