# Development Guide

This guide is for developers who want to contribute to or modify better-telescope-history.

## Prerequisites

### Required Tools

- **Neovim** >= 0.9.0
- **Lua** >= 5.1 or LuaJIT
- **Git**

### Development Tools (Optional but Recommended)

- **pre-commit** - For automated checks before commits
- **StyLua** - Lua code formatter
- **luacheck** - Lua linter
- **sqlite3** - For database inspection

## Setup Development Environment

### 1. Clone the Repository

```bash
git clone https://github.com/legrems/better-telescope-history.git
cd better-telescope-history
```

### 2. Install Development Tools

**On Ubuntu/Debian:**

```bash
# Install pre-commit
pip3 install pre-commit

# Install StyLua
cargo install stylua
# or download from: https://github.com/JohnnyMorganz/StyLua/releases

# Install luacheck
sudo apt-get install luarocks
sudo luarocks install luacheck

# Install sqlite3
sudo apt-get install sqlite3
```

**On macOS:**

```bash
# Install pre-commit
pip3 install pre-commit

# Install StyLua
brew install stylua

# Install luacheck
brew install luarocks
luarocks install luacheck

# sqlite3 is usually pre-installed
```

**On Arch Linux:**

```bash
# Install pre-commit
pip install pre-commit

# Install StyLua
yay -S stylua-bin

# Install luacheck
sudo pacman -S luarocks
sudo luarocks install luacheck

# Install sqlite3
sudo pacman -S sqlite
```

### 3. Install Pre-commit Hooks

```bash
make install
# or
pre-commit install
```

This will automatically run checks before each commit.

## Development Workflow

### Code Formatting

Format your code before committing:

```bash
make format
```

This runs StyLua on all Lua files according to `stylua.toml`.

### Linting

Check for code issues:

```bash
make lint
```

This runs luacheck according to `.luacheckrc`.

### Syntax Check

Verify Lua syntax:

```bash
make syntax-check
```

### Run All Checks

```bash
make check
```

### Pre-commit (All Checks)

Run all pre-commit hooks manually:

```bash
make pre-commit
# or
pre-commit run --all-files
```

## Making Changes

### 1. Create a Branch

```bash
git checkout -b feature/my-feature
# or
git checkout -b fix/my-bugfix
```

### 2. Make Your Changes

Edit the relevant files:

- `lua/telescope-history/*.lua` - Core modules
- `lua/telescope/_extensions/history.lua` - Telescope extension
- `plugin/telescope-history.lua` - Plugin initialization
- Documentation files as needed

### 3. Test Your Changes

**Manual Testing:**

```bash
# Use the test environment
nvim -u examples/test_setup.lua

# Or test in your own config
```

**Check Syntax:**

```bash
make check
```

### 4. Format and Lint

```bash
make format
make lint
```

### 5. Commit Your Changes

```bash
git add .
git commit -m "feat: add new feature"
```

Pre-commit hooks will run automatically. If they fail:

1. Fix the issues
1. Stage the fixes: `git add .`
1. Commit again

### 6. Push and Create PR

```bash
git push origin feature/my-feature
```

Then create a Pull Request on GitHub.

## Commit Message Guidelines

Follow conventional commits:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Examples:

```
feat: add support for git_files search type
fix: resolve database connection issue on Windows
docs: update installation instructions
refactor: simplify tracker hook logic
```

## Project Structure

```
lua/
├── telescope/_extensions/
│   └── history.lua          # Telescope picker UI
└── telescope-history/
    ├── init.lua             # Main entry point
    ├── config.lua           # Configuration management
    ├── db.lua               # Database operations
    └── tracker.lua          # Search tracking hooks

plugin/
└── telescope-history.lua    # Plugin initialization

doc/
└── telescope-history.txt    # Vim help documentation

examples/
├── config.lua               # Example configurations
└── test_setup.lua           # Testing environment
```

## Key Concepts

### Module: db.lua

Handles all SQLite operations:

- Database initialization
- Search storage
- History retrieval
- Cleanup operations

### Module: tracker.lua

Hooks into Telescope searches:

- Wraps builtin functions
- Captures search terms
- Saves to database
- Respects configuration

### Module: config.lua

Manages plugin configuration:

- Default settings
- User overrides
- Configuration validation

### Extension: history.lua

Implements the Telescope picker:

- Displays search history
- Re-executes searches
- Deletes entries

## Testing

### Manual Testing Checklist

- [ ] Install plugin in test environment
- [ ] Perform various Telescope searches
- [ ] Open history picker
- [ ] Re-execute searches from history
- [ ] Delete history entries
- [ ] Clear project history
- [ ] View statistics
- [ ] Test with different configurations
- [ ] Test ignore patterns
- [ ] Test project vs global scope

### Database Testing

Inspect the database directly:

```bash
sqlite3 ~/.local/share/nvim/telescope_history.db

# View all entries
SELECT * FROM search_history;

# Count entries per project
SELECT project_path, COUNT(*) as count
FROM search_history
GROUP BY project_path;

# View recent searches
SELECT * FROM search_history
ORDER BY timestamp DESC
LIMIT 10;
```

## Debugging

### Enable Debug Logging

Add debug prints in the code:

```lua
-- In any module
vim.notify("Debug: " .. vim.inspect(value), vim.log.levels.DEBUG)
```

### Check Module Loading

```vim
:lua print(vim.inspect(package.loaded["telescope-history"]))
```

### Reload Modules

```vim
:lua package.loaded["telescope-history"] = nil
:lua require("telescope-history").setup()
```

### Check Database Path

```vim
:lua print(vim.fn.stdpath("data") .. "/telescope_history.db")
```

## Common Issues

### Pre-commit Hooks Fail

1. Run checks manually: `make check`
1. Fix reported issues
1. Re-stage files: `git add .`
1. Commit again

### Luacheck Errors

- Check `.luacheckrc` for ignored warnings
- Add `-- luacheck: ignore` comments for false positives
- Fix actual issues

### StyLua Formatting

- Ensure `stylua.toml` exists
- Run `make format`
- Commit the formatted changes

## Useful Commands

```bash
# Full development cycle
make format && make check && git add . && git commit

# Update pre-commit hooks
make update-hooks

# Clean generated files
make clean

# See all available commands
make help
```

## Resources

- [Telescope API](https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md)
- [sqlite.lua Documentation](https://github.com/kkharji/sqlite.lua)
- [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Pre-commit Documentation](https://pre-commit.com/)

## Getting Help

- Check existing [Issues](https://github.com/legrems/better-telescope-history/issues)
- Read the [Contributing Guide](CONTRIBUTING.md)
- Ask questions in discussions

Happy coding! 🎉
