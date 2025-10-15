# Getting Started with Better Telescope History

Welcome! This guide will get you up and running in just a few minutes.

## What is This?

Better Telescope History is a Neovim plugin that remembers all your Telescope searches and lets you easily find and re-run them. Think of it as "browser history" but for your code searches!

## Why Would I Use This?

Ever found yourself:
- Typing the same search term multiple times?
- Trying to remember that perfect regex you used yesterday?
- Wishing you could see your search patterns over time?

This plugin solves those problems!

## Installation (5 minutes)

### Step 1: Install Dependencies

You need these two plugins first:

**lazy.nvim users:**
```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }
}

{
  "kkharji/sqlite.lua"
}
```

**packer.nvim users:**
```lua
use { "nvim-telescope/telescope.nvim" }
use { "kkharji/sqlite.lua" }
```

### Step 2: Install Better Telescope History

**lazy.nvim:**
```lua
{
  "legrems/better-telescope-history",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    require("telescope-history").setup()
    require("telescope").load_extension("history")
  end,
}
```

**packer.nvim:**
```lua
use {
  "legrems/better-telescope-history",
  requires = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    require("telescope-history").setup()
    require("telescope").load_extension("history")
  end,
}
```

### Step 3: Add a Keybinding (Optional but Recommended)

Add this to your Neovim config:

```lua
vim.keymap.set("n", "<leader>fh", "<cmd>TelescopeHistory<cr>", {
  desc = "Search History"
})
```

Feel free to use any key combination you like!

### Step 4: Restart Neovim

```bash
# Exit Neovim and restart
:qa
nvim
```

## First Use (2 minutes)

### 1. Do Some Searches

Use Telescope normally:
```vim
:Telescope find_files
```

Type something (e.g., "config") and press Enter.

Do a few more searches:
```vim
:Telescope live_grep
```

Type something (e.g., "function") and press Enter.

### 2. Open Your History

Now press `<leader>fh` (or run `:TelescopeHistory`)

You'll see all your recent searches! 🎉

### 3. Re-run a Search

- Navigate to any search in the list (using `j/k` or arrow keys)
- Press `Enter` to re-run that search
- It will execute the same Telescope command with the same search term!

### 4. Delete Old Searches

- Navigate to a search you want to remove
- Press `Ctrl-d` to delete it

## That's It!

You're now using Better Telescope History! 

Your searches are automatically being saved to a database, and you can access them anytime.

## What's Next?

### Learn More Commands

```vim
:TelescopeHistoryStats      " See your search statistics
:TelescopeHistoryClear      " Clear current project's history
:TelescopeHistoryClearAll   " Clear all history (asks for confirmation)
```

### Customize Your Setup

See [examples/config.lua](examples/config.lua) for configuration options.

Common customizations:

**Track more search types:**
```lua
require("telescope-history").setup({
  track_types = {
    "live_grep",
    "grep_string",
    "find_files",
    "buffers",        -- Add this
    "help_tags",      -- And this
  },
})
```

**Use global history instead of per-project:**
```lua
require("telescope-history").setup({
  scope = "global",  -- Track all searches together
})
```

**Ignore certain searches:**
```lua
require("telescope-history").setup({
  ignore_patterns = {
    "^test",      -- Don't save searches starting with "test"
    "password",   -- Don't save searches containing "password"
  },
})
```

### Read More Documentation

- **[README.md](README.md)** - Full documentation
- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference
- **[FEATURES.md](FEATURES.md)** - Complete feature list
- **`:help telescope-history`** - Built-in help docs

## Common Questions

**Q: Where is my search history stored?**

A: In a SQLite database at `~/.local/share/nvim/telescope_history.db`

**Q: Does this slow down Telescope?**

A: No! The tracking happens asynchronously and has negligible impact.

**Q: Can I share history between computers?**

A: Not automatically, but you could sync the database file via Dropbox, etc.

**Q: What if I don't want to track certain searches?**

A: Use `ignore_patterns` in your configuration (see examples above).

**Q: Can I export my history?**

A: The database is SQLite, so you can use any SQLite tool to query/export it!

## Troubleshooting

**"No search history found"**
- You need to do some Telescope searches first
- Make sure `auto_save = true` (it's the default)

**"Module 'sqlite' not found"**
- Install sqlite.lua (see Step 1 above)
- Make sure sqlite3 is installed on your system

**Other issues?**
- Check [INSTALL_VERIFICATION.md](INSTALL_VERIFICATION.md) for detailed testing
- See [README.md](README.md) troubleshooting section
- Open an issue on GitHub

## Tips & Tricks

1. **Use history to learn**: Review your stats to see what you search for most
2. **Save complex searches**: Let the plugin remember your complex regex patterns
3. **Project workflow**: Each project gets its own history (with default config)
4. **Quick access**: Set up an easy keybinding for fast access
5. **Clean up**: Periodically review and delete old searches you don't need

## Enjoy!

You're all set! This plugin will now quietly remember all your searches and make them easily accessible whenever you need them.

Happy searching! 🔍

---

Need help? Check the [README.md](README.md) or open an issue!

