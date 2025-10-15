# Contributing to Better Telescope History

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/legrems/better-telescope-history/issues)
2. If not, create a new issue using the bug report template
3. Provide as much detail as possible:
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (OS, Neovim version, etc.)
   - Your plugin configuration

### Suggesting Features

1. Check if the feature has already been requested
2. Create a new issue using the feature request template
3. Explain the use case and why it would be valuable
4. Consider whether you'd be willing to implement it

### Submitting Pull Requests

1. Fork the repository
2. Create a new branch for your feature/fix: `git checkout -b feature/my-feature`
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear, descriptive messages
6. Push to your fork
7. Open a pull request

## Development Setup

### Prerequisites

- Neovim >= 0.9.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [sqlite.lua](https://github.com/kkharji/sqlite.lua)

### Local Testing

1. Clone your fork:
```bash
git clone https://github.com/YOUR_USERNAME/better-telescope-history.git
cd better-telescope-history
```

2. Create a test Neovim configuration:
```lua
-- test_config.lua
vim.opt.runtimepath:append(".")
vim.opt.runtimepath:append("path/to/telescope.nvim")
vim.opt.runtimepath:append("path/to/sqlite.lua")

require("telescope-history").setup()
require("telescope").load_extension("history")
```

3. Test with: `nvim -u test_config.lua`

## Code Style

- Follow standard Lua conventions
- Use 2 spaces for indentation
- Keep lines under 100 characters when possible
- Add comments for complex logic
- Use descriptive variable and function names

### Formatting

If you have [StyLua](https://github.com/JohnnyMorganz/StyLua) installed:
```bash
stylua lua/
```

## Project Structure

```
better-telescope-history/
├── lua/
│   ├── telescope/
│   │   └── _extensions/
│   │       └── history.lua          # Telescope extension & picker
│   └── telescope-history/
│       ├── init.lua                  # Main entry point
│       ├── config.lua                # Configuration management
│       ├── db.lua                    # Database operations
│       └── tracker.lua               # Search tracking logic
├── plugin/
│   └── telescope-history.lua        # Plugin initialization
├── doc/
│   └── telescope-history.txt        # Vim help documentation
└── examples/
    └── config.lua                   # Example configurations
```

## Testing Guidelines

When submitting changes:

1. Test with the default configuration
2. Test with custom configurations (different scope, track_types, etc.)
3. Test all commands (`:TelescopeHistory`, `:TelescopeHistoryClear`, etc.)
4. Test the picker functionality (navigation, selection, deletion)
5. Verify database operations work correctly
6. Test with different Telescope search types

## Documentation

When adding features:

1. Update the README.md with usage examples
2. Update doc/telescope-history.txt with API documentation
3. Add examples to examples/config.lua if relevant
4. Update CHANGELOG.md

## Commit Messages

Use clear, descriptive commit messages:

- `feat: add support for git_files search type`
- `fix: resolve database connection issue`
- `docs: update installation instructions`
- `refactor: simplify tracker hook logic`
- `test: add tests for db cleanup`

## Questions?

Feel free to:
- Open an issue for discussion
- Ask questions in existing issues/PRs
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing! 🎉

