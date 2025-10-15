# Quick Start Guide

Get up and running with Better Telescope History in 5 minutes!

## 1. Install Dependencies

Make sure you have these installed first:

```lua
-- Using lazy.nvim
{
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }
}

{
  "kkharji/sqlite.lua"
}
```

## 2. Install Better Telescope History

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

## 3. Add a Keybinding

Add this to your config:

```lua
vim.keymap.set("n", "<leader>fh", "<cmd>TelescopeHistory<cr>", {
  desc = "Search History"
})
```

## 4. Use It!

1. Do some searches with Telescope (`:Telescope live_grep`, `:Telescope find_files`, etc.)
2. Press `<leader>fh` to open your search history
3. Navigate to a previous search and press `<CR>` to re-execute it
4. Press `<C-d>` to delete a history entry

## 5. That's It!

Your searches are now being automatically tracked and stored in a SQLite database.

## Common Customizations

### Track More Search Types

```lua
require("telescope-history").setup({
  track_types = {
    "live_grep",
    "grep_string",
    "find_files",
    "buffers",
    "help_tags",
  },
})
```

### Use Global History (Instead of Per-Project)

```lua
require("telescope-history").setup({
  scope = "global",
})
```

### Ignore Certain Searches

```lua
require("telescope-history").setup({
  ignore_patterns = {
    "^test",      -- Ignore searches starting with "test"
    "password",   -- Ignore searches containing "password"
  },
})
```

## Troubleshooting

### "sqlite.lua not found"

Install sqlite.lua: see the [sqlite.lua installation guide](https://github.com/kkharji/sqlite.lua#installation)

### "No search history found"

Make sure:
1. You've done some Telescope searches after installing
2. `auto_save = true` in your config (it's the default)
3. The search type is in your `track_types` list

### Where is my database?

Run this in Neovim:
```vim
:lua print(vim.fn.stdpath("data") .. "/telescope_history.db")
```

## Next Steps

- Read the full [README.md](README.md) for all features
- Check [examples/config.lua](examples/config.lua) for more configuration examples
- Run `:help telescope-history` for complete documentation

Happy searching! 🔍

