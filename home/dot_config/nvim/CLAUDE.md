# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration built using lazy.nvim, modeled after carlhuda's Janus Vim distribution with Lua-native plugin replacements. The configuration follows a modular structure:

- `init.lua`: Main entry point that loads all configuration modules
- `lua/config/lazy.lua`: Lazy.nvim bootstrap and setup with leader key configuration
- `lua/config/settings.lua`: Basic vim settings (numbers, spell check, file handling)
- `lua/config/keymaps.lua`: Key mappings for Git, testing, file navigation, etc.
- `lua/config/plugin-config.lua`: Plugin-specific configurations and variables
- `lua/config/commands/`: Custom Neovim commands and functionality
- `lua/plugins/`: Plugin specifications organized by functionality

## Key Configuration Details

### Plugin Management
- Uses lazy.nvim as the plugin manager
- Leader key is set to backslash (`"\"`) and local leader to backslash (`"\"`)  
- Plugin specifications are imported from the `lua/plugins/` directory
- Auto-updates are enabled for plugins

### Current Plugins
This configuration includes a comprehensive set of plugins ported from the original .vimrc:

**File Management & Navigation:**
- `nvim-neo-tree/neo-tree.nvim`: Modern file explorer with Git integration
- `nvim-telescope/telescope.nvim`: Fuzzy finder for files, buffers, and live grep
- `jeetsukumaran/vim-buffergator`: Buffer navigation

**Development Tools:**
- `tpope/vim-fugitive`: Git integration
- `vim-test/vim-test`: Test runner integration
- `mfussenegger/nvim-lint`: Modern linting with native LSP integration
- `stevearc/conform.nvim`: Code formatting
- `tpope/vim-dispatch`: Asynchronous build and test dispatcher

**Language Support:**
- `sheerun/vim-polyglot`: Multi-language syntax pack
- `tpope/vim-rails`: Ruby on Rails support
- `posva/vim-vue`: Vue.js support
- `tpope/vim-fireplace`: Clojure REPL integration
- Multiple language-specific plugins for JavaScript, Ruby, etc.

**UI & Themes:**
- `nvim-lualine/lualine.nvim`: Modern Lua-based statusline
- `NLKNguyen/papercolor-theme`: PaperColor theme (default)
- `lifepillar/vim-solarized8`: Solarized theme option

**Completion & Snippets:**
- `hrsh7th/nvim-cmp`: Modern completion engine with LSP support
- `L3MON4D3/LuaSnip`: Snippet engine

**Motion & Editing:**
- `folke/flash.nvim`: Jump/motion plugin (Lua replacement for vim-easymotion)
- `lukas-reineke/indent-blankline.nvim`: Indent guides (Lua replacement for vim-indent-guides)

**Git Gutter:**
- `lewis6991/gitsigns.nvim`: Git change indicators in the sign column

**Utilities:**
- `mbbill/undotree`: Advanced undo history visualization

### Custom Commands
- `OpenLine`: Opens the current line as a file path and creates a tmux window in that directory
- `ClSort`: Converts all lines to comma-separated list, sorts them, and copies to clipboard
- `ClSortTags`: Converts lines to camelCase Twitter hashtags, sorts and copies to clipboard

## Development Workflow

### Plugin Management Commands (in Neovim)
- `:Lazy`: Open the lazy.nvim plugin manager interface
- `:Lazy update`: Update all plugins
- `:Lazy install`: Install missing plugins
- `:Lazy clean`: Remove unused plugins
- `:Lazy sync`: Run install, clean, and update

### File Structure for New Plugins
When adding new plugins:
1. Create a new `.lua` file in `lua/plugins/`
2. Return a plugin specification table with the plugin's GitHub repository
3. Include configuration in the `config` function if needed

### Testing Configuration Changes
- Restart Neovim after making changes to core configuration files
- Use `:source %` to reload the current Lua file during development
- Check `:checkhealth` to diagnose any configuration issues

### Key Mappings (Leader = \)
**File Navigation:**
- `<leader>n`: Toggle Neo-tree
- `<leader>r`: Reveal current file in Neo-tree
- `<C-o>`: Focus Neo-tree with current file

**Telescope (Search & Find):**
- `<leader>ff`: Find files
- `<leader>fg`: Live grep (search in files)
- `<leader>fb`: Find buffers
- `<leader>fh`: Help tags
- `<leader>f`: Search with live grep

**Git Operations:**
- `<leader>gb`: Git blame
- `<leader>gq`: Git status
- `<leader>gd`: Git diff
- `<leader>gl`: Git log
- `<leader>gc`: Git commit
- `<leader>gv`: Git commit all
- `<leader>gp`: Git push

**Testing:**
- `<leader>tn`: Test nearest
- `<leader>tf`: Test file
- `<leader>ts`: Test suite
- `<leader>tl`: Test last
- `<leader>tv`: Test visit

**Window Management (Janus-style):**
- `<C-h/j/k/l>`: Navigate between windows
- `<leader>hs`: Horizontal split
- `<leader>vs`: Vertical split
- `<leader>=`: Equalize window sizes
- `<leader>]`: Next buffer
- `<leader>[`: Previous buffer
- `<leader>hl`: Clear search highlight

**Motion:**
- `s`: Flash jump (easymotion-style)
- `S`: Flash treesitter jump

**Git Hunks:**
- `]c` / `[c`: Next/previous git hunk
- `<leader>hp`: Preview hunk
- `<leader>hr`: Reset hunk
- `<leader>hb`: Blame line

**Other:**
- `<leader>fef`: Format entire file
- `<leader>rc`: Run RuboCop with auto-correct
- `<leader>u`: Toggle undo tree
- `<F2>`: Show current time

## Important Files
- `lazy-lock.json`: Lockfile containing exact plugin versions (commit to version control)
- `init.vim`: Legacy Vim configuration file (currently empty)
- `~/.vimrc`: Original vim configuration that this Neovim config mirrors