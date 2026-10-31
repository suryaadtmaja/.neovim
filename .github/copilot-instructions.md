<!-- Copilot instructions for AI coding agents working on this Neovim config -->
# Project snapshot

This repository is a personal Neovim configuration (Lua). Key entrypoints:

- `init.lua` — top-level bootstrap that requires the main modules.
- `lua/packages/init.lua` — central plugin loader using `lazy.nvim` and a local helper `packages._lazy`.
- `lua/nvim-config.lua` — user keymaps and small runtime behaviors (e.g., restart mapping).
- `lua/ide/lsp/*` — LSP and debugging setup (language servers under `servers/`, adapters under `debugging/`).
- `lua/ui/lualine/` — custom statusline helpers (e.g., `copilot_status.lua`).

# Big picture

- This is not a typical app — it is a config tree. Plugins are registered via `lazy.setup` in `lua/packages/init.lua` and grouped by lazy-loading hooks: `eagerly`, `on_insert_enter`, `lazily`, `on_buf_read`, and `on_idle`.
- Many plugin wrappers are small modules under `lua/ide/`, `lua/tools/`, and `lua/ui/`. Files prefixed with an underscore (e.g., `_cmp.lua`, `_treesitter.lua`) are plugin-config modules intended to be `require`d from `packages.init`.
- Language server config is split into `lua/ide/lsp/servers/*.lua` — adding or tuning LSPs should update these files.

# Project-specific conventions (important for edits)

- Plugin modules: use `require("ide._name")` or `require("tools._name")` style; prefer adding a new `_module.lua` and referencing it from `lua/packages/init.lua` rather than inlining registrations.
- File prefixes: `_` files are small plugin wrappers; non-underscore files are broader feature sets.
- Do not replace `lazy.nvim` usage pattern — preserve `load.eagerly/on_insert_enter/on_buf_read/on_idle` groupings when adding plugins.
- `lazy-lock.json` is present; when adding plugins, update the lockfile and prefer deterministic pins.

# Workflows and useful commands

- Interactive plugin management: open Neovim and run `:Lazy` to inspect/install/update plugins.
- Headless sync (CI / scripted): `nvim --headless -c 'Lazy sync' -c 'quit'` (run locally to verify changes to plugin list).
- After changing LSP server config, start `nvim` and run `:LspInfo` or `:checkhealth` to validate setup.

# Integration points & external deps

- Uses `lazy.nvim` as plugin manager (bootstrap helper in `lua/packages/_lazy.lua`).
- LSPs are configured in `lua/ide/lsp/servers/*.lua` — common external tools (mason, gopls, tsserver, etc.) are expected but declare exact servers in those files.
- Debugging adapters live in `lua/ide/lsp/debugging/` (e.g., `js-dap.lua`, `go-dap.lua`).

# Guidance for AI edits (be conservative & specific)

- Prefer small, focused PRs: change one plugin/module at a time and update `lua/packages/init.lua` accordingly.
- When adding a plugin: add a `_module.lua` under the appropriate folder (e.g., `lua/tools/`), reference it from the matching `load.*` group, and run `:Lazy sync` + quick `:checkhealth`.
- When tuning LSPs, edit `lua/ide/lsp/servers/<server>.lua` — do not scatter server config across unrelated files.
- Respect user keybinding patterns in `lua/nvim-config.lua` (example: restart mapping that calls `persistence.save()` then `os.exit(1)`).

# Quick references

- Bootstrap and plugin groups: `lua/packages/init.lua`
- Keymaps and runtime tweaks: `lua/nvim-config.lua`
- LSP entry: `lua/ide/lsp/init.lua` and `lua/ide/lsp/servers/`
- Statusline & UI: `lua/ui/` (see `lua/ui/lualine/`)

