# Better Telescope History

A Neovim plugin that enhances Telescope by storing and managing your search history in a local SQLite database. Never lose track of your searches again!

## Features

- 📝 **Persistent Search History**: Automatically stores all your Telescope searches in a SQLite database
- 🗂️ **Project-Based Organization**: Tracks history per project/path or globally
- 🔍 **Search History Picker**: Easily browse and re-execute past searches
- ⚙️ **Configurable**: Customize what searches to track, storage limits, and more
- 🎯 **Multiple Search Types**: Supports `live_grep`, `grep_string`, `find_files`, and more
- 📊 **Statistics**: View statistics about your search patterns
- 🗑️ **History Management**: Clear history per project or globally

## Requirements

- Neovim >= 0.9.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [sqlite.lua](https://github.com/kkharji/sqlite.lua) - For SQLite database support

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "legrems/better-telescope-history",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    require("telescope-history").setup({
      -- Configuration options (see below)
    })
    
    -- Load the Telescope extension
    require("telescope").load_extension("history")
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "legrems/better-telescope-history",
  requires = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    require("telescope-history").setup({
      -- Configuration options (see below)
    })
    require("telescope").load_extension("history")
  end,
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-telescope/telescope.nvim'
Plug 'kkharji/sqlite.lua'
Plug 'legrems/better-telescope-history'
```

Then in your `init.lua`:

```lua
require("telescope-history").setup()
require("telescope").load_extension("history")
```

## Configuration

Here are the default configuration options:

```lua
require("telescope-history").setup({
  -- Scope of history: "project" (per project) or "global" (all projects)
  scope = "project",
  
  -- Maximum number of entries to store per project/globally
  max_entries = 1000,
  
  -- Maximum number of results to show in the history picker
  max_results = 100,
  
  -- Search types to track
  track_types = {
    "live_grep",
    "grep_string",
    "find_files",
  },
  
  -- Automatically save searches (disable to manually save)
  auto_save = true,
  
  -- Patterns to ignore (don't save searches matching these Lua patterns)
  ignore_patterns = {
    -- Example: "^test",  -- Ignore searches starting with "test"
  },
})
```

## Usage

### Open Search History

After installation, you can open the search history picker using any of these methods:

**Command:**
```vim
:TelescopeHistory
```

**Lua:**
```lua
require("telescope").extensions.history.history()
```

**Keybinding (add to your config):**
```lua
vim.keymap.set("n", "<leader>fh", "<cmd>TelescopeHistory<cr>", { desc = "Search History" })
-- or
vim.keymap.set("n", "<leader>fh", function()
  require("telescope").extensions.history.history()
end, { desc = "Search History" })
```

### History Picker Features

In the history picker:
- **`<CR>`** (Enter): Re-execute the selected search
- **`<C-d>`**: Delete the selected history entry
- Navigate with **`j/k`** or **`<Up>/<Down>`**
- Search/filter with **`/`** or just start typing

### Additional Commands

**Clear Project History:**
```vim
:TelescopeHistoryClear
```
Clears search history for the current project.

**Clear All History:**
```vim
:TelescopeHistoryClearAll
```
Clears all search history (requires confirmation).

**View Statistics:**
```vim
:TelescopeHistoryStats
```
Shows statistics about your search history including total searches, searches by project, and searches by type.

## How It Works

1. **Automatic Tracking**: When `auto_save` is enabled, the plugin hooks into Telescope's builtin functions and automatically saves each search to the SQLite database.

2. **Database Location**: The SQLite database is stored at `~/.local/share/nvim/telescope_history.db` (or your configured data directory).

3. **Project Detection**: The plugin uses `vim.loop.cwd()` to determine the current project path for project-scoped history.

4. **Smart Cleanup**: Old entries are automatically removed when the configured `max_entries` limit is reached.

## Examples

### Example 1: Quick Search History Access

```lua
-- Add a keybinding to quickly access your search history
vim.keymap.set("n", "<leader>sh", "<cmd>TelescopeHistory<cr>", { desc = "Search History" })
```

### Example 2: Global Search History

If you want to track all searches globally instead of per-project:

```lua
require("telescope-history").setup({
  scope = "global",
})
```

### Example 3: Ignore Certain Searches

```lua
require("telescope-history").setup({
  ignore_patterns = {
    "^test",      -- Ignore searches starting with "test"
    "%.tmp$",     -- Ignore searches ending with ".tmp"
    "password",   -- Ignore searches containing "password"
  },
})
```

### Example 4: Track More Search Types

```lua
require("telescope-history").setup({
  track_types = {
    "live_grep",
    "grep_string",
    "find_files",
    "buffers",
    "help_tags",
    "oldfiles",
  },
})
```

### Example 5: Manual History Saving

If you prefer to manually save searches:

```lua
require("telescope-history").setup({
  auto_save = false,
})

-- Then manually save searches when needed
local history = require("telescope-history")
history.tracker.save_search("my search term", "live_grep")
```

## Troubleshooting

### SQLite.lua Issues

If you encounter issues with `sqlite.lua`, make sure it's properly installed:

```bash
# The plugin should work out of the box, but if you have issues:
# Make sure sqlite3 is installed on your system
# Ubuntu/Debian:
sudo apt-get install sqlite3 libsqlite3-dev

# macOS:
brew install sqlite3

# Arch Linux:
sudo pacman -S sqlite
```

### History Not Saving

1. Check that `auto_save` is enabled in your configuration
2. Verify that the search type is in your `track_types` list
3. Check that the search doesn't match any `ignore_patterns`
4. Run `:TelescopeHistoryStats` to see if any searches were recorded

### Database Location

To find where your database is stored:

```lua
:lua print(vim.fn.stdpath("data") .. "/telescope_history.db")
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Credits

Built with:
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - The extensible fuzzy finder
- [sqlite.lua](https://github.com/kkharji/sqlite.lua) - SQLite/LuaJIT binding

---

Made with ❤️ for the Neovim community

