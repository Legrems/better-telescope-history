# Installation Verification Guide

Use this guide to verify that Better Telescope History is correctly installed and working.

## Quick Verification

Run these commands in Neovim to verify installation:

### 1. Check Plugin is Loaded

```vim
:lua print(vim.g.loaded_telescope_history)
```

**Expected**: Should print `1` or `true`

### 2. Check Extension is Registered

```vim
:lua print(vim.inspect(require("telescope").extensions.history))
```

**Expected**: Should print a table with `history` key

### 3. Check Commands are Available

```vim
:TelescopeHistory
```

**Expected**: Opens the history picker (may be empty if no searches yet)

### 4. Check Database Module

```vim
:lua local db = require("telescope-history.db"); print("DB module loaded")
```

**Expected**: Should print "DB module loaded" without errors

## Detailed Verification

### Step 1: Verify Dependencies

```vim
" Check Telescope
:lua print(pcall(require, "telescope"))

" Check sqlite.lua
:lua print(pcall(require, "sqlite"))
```

**Expected**: Both should print `true`

### Step 2: Check Configuration

```vim
:lua print(vim.inspect(require("telescope-history.config").get()))
```

**Expected**: Should print your configuration table

### Step 3: Test Search Tracking

1. Run a Telescope search:
```vim
:Telescope find_files
```

2. Type something in the prompt and press Enter

3. Check if it was saved:
```vim
:lua local db = require("telescope-history.db"); local h = db.get_history(vim.loop.cwd(), 10); print(#h .. " entries")
```

**Expected**: Should show at least 1 entry

### Step 4: Test History Picker

1. Open the history picker:
```vim
:TelescopeHistory
```

2. You should see your previous search
3. Press Enter to re-execute it
4. Press Ctrl-d to delete an entry

**Expected**: Should work without errors

### Step 5: Test Commands

```vim
" View statistics
:TelescopeHistoryStats

" Clear project history (confirm it works)
:TelescopeHistoryClear

" Check all cleared
:lua local db = require("telescope-history.db"); print(#db.get_history(vim.loop.cwd(), 10))
```

**Expected**: Should show 0 entries after clearing

## Troubleshooting

### Error: "module 'telescope-history' not found"

**Problem**: Plugin not in Neovim's runtime path

**Solutions**:
1. Check your package manager installed it correctly
2. Verify the plugin directory is in `:lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))`
3. Try restarting Neovim

### Error: "module 'sqlite' not found"

**Problem**: sqlite.lua not installed

**Solutions**:
1. Install sqlite.lua: Add to your plugin manager
2. Check system has sqlite3: `which sqlite3`
3. On Linux: `sudo apt-get install sqlite3 libsqlite3-dev`
4. On macOS: `brew install sqlite3`

### Error: "telescope not found"

**Problem**: Telescope.nvim not installed

**Solutions**:
1. Install telescope.nvim via your package manager
2. Ensure it's loaded before better-telescope-history

### Warning: "No search history found"

**Not an error**: This means you haven't done any searches yet

**To fix**:
1. Run some Telescope searches first
2. Make sure `auto_save = true` in your config
3. Check the search type is in your `track_types` list

### Database Location Issues

**Check where database is**:
```vim
:lua print(vim.fn.stdpath("data") .. "/telescope_history.db")
```

**Check if database exists**:
```bash
ls -lah ~/.local/share/nvim/telescope_history.db
```

**Check permissions**:
```bash
ls -la ~/.local/share/nvim/ | grep telescope_history
```

**Should be readable/writable by your user**

## Complete Test Script

Save this to `test_installation.lua` and run with `:source %`:

```lua
local function test_installation()
  local results = {}
  
  -- Test 1: Plugin loaded
  local ok, loaded = pcall(function() return vim.g.loaded_telescope_history end)
  results["Plugin Loaded"] = ok and loaded or false
  
  -- Test 2: Module available
  ok = pcall(require, "telescope-history")
  results["Module Available"] = ok
  
  -- Test 3: Telescope extension registered
  ok = pcall(function() return require("telescope").extensions.history end)
  results["Extension Registered"] = ok
  
  -- Test 4: Database module
  ok = pcall(require, "telescope-history.db")
  results["Database Module"] = ok
  
  -- Test 5: Config module
  ok = pcall(require, "telescope-history.config")
  results["Config Module"] = ok
  
  -- Test 6: Tracker module
  ok = pcall(require, "telescope-history.tracker")
  results["Tracker Module"] = ok
  
  -- Test 7: Commands available
  local commands = vim.api.nvim_get_commands({})
  results["Commands Registered"] = commands["TelescopeHistory"] ~= nil
  
  -- Print results
  print("\n=== Installation Verification Results ===")
  for test, result in pairs(results) do
    local status = result and "✓ PASS" or "✗ FAIL"
    print(string.format("%s: %s", status, test))
  end
  
  local all_pass = true
  for _, result in pairs(results) do
    if not result then
      all_pass = false
      break
    end
  end
  
  if all_pass then
    print("\n✓ All tests passed! Installation successful.")
  else
    print("\n✗ Some tests failed. Check errors above.")
  end
  print("=========================================\n")
  
  return all_pass
end

test_installation()
```

## Manual Testing Checklist

- [ ] Plugin loads without errors
- [ ] Telescope extension registered
- [ ] Can open history picker with `:TelescopeHistory`
- [ ] Can perform Telescope searches
- [ ] Searches are automatically saved
- [ ] Can view saved searches in history picker
- [ ] Can re-execute searches by pressing Enter
- [ ] Can delete entries with Ctrl-d
- [ ] Can view statistics with `:TelescopeHistoryStats`
- [ ] Can clear history with `:TelescopeHistoryClear`
- [ ] Configuration is applied correctly
- [ ] Database file is created
- [ ] No performance issues during searches

## Getting Help

If verification fails:

1. Check the [README.md](README.md) for detailed setup
2. Review [QUICKSTART.md](QUICKSTART.md) for simple setup
3. Check [examples/config.lua](examples/config.lua) for config examples
4. Open an issue on GitHub with:
   - Your configuration
   - Error messages
   - Neovim version
   - OS information

## Success!

If all tests pass, you're ready to use Better Telescope History!

Try:
- `:Telescope find_files` - Do some searches
- `:TelescopeHistory` - Browse your history
- `:TelescopeHistoryStats` - See your search patterns

Happy searching! 🎉

