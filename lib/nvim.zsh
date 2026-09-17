# lib/nvim.zsh — run Neovim headlessly for the nvim steps. Sourced, never executed.

# nvim_headless <label> [nvim args...] — start nvim with the real config, run
# the given commands in order, quit. Fails if nvim exits non-zero or its
# output looks like a Lua/Vim error, and prints the captured output then.
nvim_headless() {
    local label=$1; shift
    local log
    log=$(mktemp)
    info "$label"
    if ! nvim --headless "$@" +qa > "$log" 2>&1; then
        err "$label: nvim exited with an error"
        cat "$log" >&2
        rm -f "$log"
        return 1
    fi
    if grep -qE 'E[0-9]+:|Error executing|Error detected|Error in |Failed to|stack traceback' "$log"; then
        err "$label: nvim reported errors"
        cat "$log" >&2
        rm -f "$log"
        return 1
    fi
    rm -f "$log"
    ok "$label"
}

# nvim_headless_lua <label> <lua source> [nvim args...] — same, running the
# given args first and then a multi-line Lua snippet.
nvim_headless_lua() {
    local label=$1 code=$2 script rc
    shift 2
    script=$(mktemp -t dots-nvim).lua
    print -r -- "$code" > "$script"
    nvim_headless "$label" "$@" "+luafile $script"
    rc=$?
    rm -f "$script"
    return $rc
}

# Build every parser listed in lua/plugins/treesitter.lua. The config already
# starts this install asynchronously at startup; calling install() again for
# the same list returns a task we can block on (already-installed parsers are
# skipped), so nvim can't quit mid-build.
NVIM_PARSERS_LUA='
local parsers = require("plugins.treesitter").parsers
require("nvim-treesitter").install(parsers):wait(600000)
print("treesitter: " .. #parsers .. " parsers present")
'

# Make sure everything in mason.nvim's ensure_installed list is installed.
# The list is read from the live lazy.nvim spec so it only lives in
# lua/plugins/mason.lua. That config also starts installing missing packages
# on its own (asynchronously) at startup, so: give it a moment to start,
# install only what it didn't touch, then wait for everything in flight.
# :MasonInstall blocks when nvim is headless.
NVIM_MASON_ENSURE_LUA="$NVIM_PARSERS_LUA"'
local plugin = require("lazy.core.config").plugins["mason.nvim"]
local opts = require("lazy.core.plugin").values(plugin, "opts", false)
local registry = require("mason-registry")
registry.refresh()
local pkgs = {}
for _, name in ipairs(opts.ensure_installed) do
  table.insert(pkgs, registry.get_package(name))
end
local function settled(pkg) return pkg:is_installed() or pkg:is_installing() end
local function all(pred)
  for _, pkg in ipairs(pkgs) do
    if not pred(pkg) then return false end
  end
  return true
end
vim.wait(30000, function() return all(settled) end, 250)
local missing = {}
for _, pkg in ipairs(pkgs) do
  if not settled(pkg) then table.insert(missing, pkg.name) end
end
if #missing > 0 then
  vim.cmd("MasonInstall " .. table.concat(missing, " "))
end
vim.wait(600000, function() return all(function(pkg) return not pkg:is_installing() end) end, 500)
for _, pkg in ipairs(pkgs) do
  if not pkg:is_installed() then
    error("Mason: " .. pkg.name .. " is not installed")
  end
end
print("Mason: all " .. #pkgs .. " packages installed")
'

# Upgrade every installed Mason package to its latest registry version.
NVIM_MASON_UPGRADE_LUA="$NVIM_PARSERS_LUA"'
local registry = require("mason-registry")
registry.refresh()
local function none_installing()
  for _, pkg in ipairs(registry.get_installed_packages()) do
    if pkg:is_installing() then return false end
  end
  return true
end
vim.wait(600000, none_installing, 500)
local pending = 0
for _, pkg in ipairs(registry.get_installed_packages()) do
  local latest = pkg:get_latest_version()
  if latest ~= pkg:get_installed_version() then
    pending = pending + 1
    print("Mason: " .. pkg.name .. " " .. tostring(pkg:get_installed_version()) .. " -> " .. tostring(latest))
    pkg:install({ version = latest }):once("closed", function() pending = pending - 1 end)
  end
end
vim.wait(600000, function() return pending == 0 end, 200)
print("Mason: packages up to date")
'
