# dotfiles

macOS setup: apps, shell, git, tmux, Neovim, terminals, fonts. One tool,
`./dots`, installs and updates all of it, and every step can be re-run.

## New Mac

```sh
curl -fsSL https://raw.githubusercontent.com/ameliagapin/dotfiles/master/bootstrap | zsh
```

That installs the Xcode Command Line Tools, clones this repo to
`~/Projects/dotfiles` and opens the menu. Or by hand:

```sh
xcode-select --install
git clone https://github.com/ameliagapin/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles && ./dots
```

Nothing else is needed first — `dots` is plain zsh.

## Usage

```
./dots                 # interactive menu: ↑/↓ or j/k, Enter runs a step, a runs all, q quits
./dots homebrew nvim   # run specific steps
./dots --all           # run everything in order
./dots --list          # list steps
```

| step          | what it does |
|---------------|--------------|
| `xcode`       | Command Line Tools; accepts the Xcode license if Xcode.app is installed |
| `homebrew`    | installs Homebrew, then `brew bundle` from [`apps/homebrew/Brewfile`](apps/homebrew/Brewfile), `brew upgrade`, `brew cleanup` |
| `zsh`         | Oh My Zsh, spaceship prompt, autosuggestions/syntax-highlighting; links `~/.zshrc` & co; zsh as login shell |
| `git`         | `~/.gitconfig` |
| `ssh`         | `~/.ssh/config` |
| `tmux`        | `~/.tmux.conf` |
| `ghostty`     | `~/.config/ghostty` |
| `iterm`       | `~/.iterm`, and points iTerm2's preferences at it |
| `nvim`        | `~/.config/nvim`, plugins from `lazy-lock.json`, treesitter parsers, LSP servers via Mason |
| `nvim-update` | updates plugins, parsers and Mason packages to latest (then commit `lazy-lock.json`) |
| `fonts`       | copies `apps/fonts` into `~/Library/Fonts` |
| `raycast`     | `~/.raycast-scripts` (add it as a script directory in Raycast) |

## Updating

`./dots --all` is the update routine: Homebrew upgrades, shell plugins pull,
Neovim plugins/parsers/servers update, links are re-checked. Run just
`homebrew` or `nvim-update` for the usual case.

## Layout

```
dots            entrypoint (menu + CLI)
bootstrap       curl-able first-run script
lib/            helpers: link, ensure_line_in_file, confirm, nvim_headless, the menu
steps/NN-x.zsh  one file per step: STEP_NAME, STEP_DESC, step_run()
apps/<app>/     the actual config files
```

To add a step, drop a file in `steps/` — the number sets the order:

```zsh
STEP_NAME="thing"
STEP_DESC="Link ~/.thingrc"

step_run() {
    link "$DOTS_DIR/apps/thing/thingrc" "$HOME/.thingrc"
}
```

Steps run with `set -e`, so any failing command marks the step failed and
the menu carries on. Machine-local files that shouldn't be committed
(`apps/zsh/sublime`, `hinge`, `1password`) are gitignored and linked only
when present.
