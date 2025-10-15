# Feature Overview

A comprehensive list of all features in Better Telescope History.

## Core Features

### 1. Persistent Search History
- **What**: All Telescope searches are automatically saved to a SQLite database
- **Why**: Never lose track of useful searches; revisit them anytime
- **Where**: Database stored at `~/.local/share/nvim/telescope_history.db`

### 2. Project-Based Organization
- **What**: Track history per project or globally
- **Why**: Keep different projects' search histories separate
- **How**: Configure with `scope = "project"` or `scope = "global"`

### 3. Interactive History Picker
- **What**: Telescope-powered picker to browse search history
- **Why**: Familiar UI consistent with Telescope
- **Features**:
  - Formatted display with timestamp, type, and search term
  - Preview pane with search details
  - Re-execute searches with `<CR>`
  - Delete entries with `<C-d>`
  - Filter with fuzzy matching

### 4. Automatic Tracking
- **What**: Hooks into Telescope searches automatically
- **Why**: Zero friction - just use Telescope normally
- **Types Supported**:
  - `live_grep` - Live text search
  - `grep_string` - Search for string under cursor
  - `find_files` - File name search
  - (Configurable - add more types)

### 5. Smart Search Re-execution
- **What**: Detects search type and re-runs with appropriate command
- **Why**: Different search types require different Telescope commands
- **How**: 
  - `live_grep` → runs `live_grep` with search term as default
  - `grep_string` → runs `grep_string` with exact term
  - `find_files` → runs `find_files` with search term

## Management Features

### 6. History Statistics
- **Command**: `:TelescopeHistoryStats`
- **Shows**:
  - Total number of searches
  - Searches per project
  - Searches per type
- **Display**: Floating window with formatted output

### 7. Selective History Clearing
- **Project Clear**: `:TelescopeHistoryClear` - Clear current project only
- **Global Clear**: `:TelescopeHistoryClearAll` - Clear all history (with confirmation)
- **Individual Delete**: `<C-d>` in picker - Delete single entry

### 8. Automatic Cleanup
- **What**: Maintains storage limits automatically
- **How**: When max_entries is reached, oldest entries are removed
- **Configure**: `max_entries = 1000` (default)

## Configuration Features

### 9. Flexible Scope
```lua
scope = "project"  -- Per-project tracking (default)
scope = "global"   -- Track all searches together
```

### 10. Customizable Tracking
```lua
track_types = {
  "live_grep",
  "grep_string", 
  "find_files",
  "buffers",        -- Add more types
  "help_tags",
  -- etc.
}
```

### 11. Ignore Patterns
```lua
ignore_patterns = {
  "^test",       -- Don't save searches starting with "test"
  "password",    -- Don't save searches containing "password"
  "%.tmp$",      -- Don't save searches ending with ".tmp"
}
```

### 12. Storage Limits
```lua
max_entries = 1000   -- Max total entries to store
max_results = 100    -- Max results to show in picker
```

### 13. Auto-save Toggle
```lua
auto_save = true   -- Automatic tracking (default)
auto_save = false  -- Manual saving only
```

## User Experience Features

### 14. User Commands
- `:TelescopeHistory` - Open history picker
- `:TelescopeHistoryClear` - Clear project history
- `:TelescopeHistoryClearAll` - Clear all history
- `:TelescopeHistoryStats` - View statistics

### 15. Vim Help Integration
- Full documentation in `:help telescope-history`
- Searchable help tags
- API documentation

### 16. Easy Keybinding Setup
```lua
vim.keymap.set("n", "<leader>fh", "<cmd>TelescopeHistory<cr>")
```

### 17. Visual Feedback
- Notifications for actions (clear, delete, etc.)
- Formatted picker display
- Color-coded entry types

## Advanced Features

### 18. Manual Save Support
When `auto_save = false`:
```lua
require("telescope-history").tracker.save_search("term", "type")
```

### 19. Direct Database Access
```lua
local db = require("telescope-history.db")
db.add_search(term, type, path)
db.get_history(path, limit)
db.get_stats()
```

### 20. Non-intrusive Integration
- Doesn't modify Telescope behavior
- No performance impact
- Can be disabled per-session
- Works alongside other Telescope extensions

## Quality of Life

### 21. Empty State Handling
- Friendly message when no history exists
- Doesn't error on empty database

### 22. Project Detection
- Automatic via `vim.loop.cwd()`
- Works with any project structure
- No configuration needed

### 23. Database Initialization
- Auto-creates database on first use
- No manual setup required
- Handles migrations gracefully

### 24. Error Handling
- Graceful fallbacks
- Clear error messages
- Won't crash Neovim

## Developer Features

### 25. Extensible Architecture
- Modular design
- Clear separation of concerns
- Easy to add new features

### 26. Well Documented Code
- Inline comments
- Clear function names
- Comprehensive README

### 27. Example Configurations
- Multiple use case examples
- Test setup included
- Quick start guide

## Performance Features

### 28. Efficient Database Queries
- Indexed searches
- Limit-based queries
- Pagination support

### 29. Lazy Loading
- Extension loads only when needed
- Minimal startup impact

### 30. Optimized Hooks
- Minimal overhead
- Only tracks configured types
- Respects ignore patterns early

## Summary

Better Telescope History provides **30+ features** covering:
- ✅ Search persistence and tracking
- ✅ Project organization
- ✅ History management
- ✅ Extensive configuration
- ✅ Great user experience
- ✅ Developer-friendly
- ✅ Performance optimized

All while maintaining **zero friction** - just install, configure, and use Telescope normally!

