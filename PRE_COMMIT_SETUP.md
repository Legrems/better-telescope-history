# Pre-commit Setup Guide

This project uses pre-commit hooks to ensure code quality and consistency.

## Quick Setup

### Automatic Setup (Recommended)

```bash
./scripts/setup-dev.sh
```

This script will:

- Check for required tools
- Install pre-commit
- Set up pre-commit hooks
- Provide guidance for missing tools

### Manual Setup

1. **Install pre-commit:**

   ```bash
   pip install pre-commit
   # or
   pip3 install --user pre-commit
   ```

1. **Install hooks:**

   ```bash
   pre-commit install
   # or
   make install
   ```

1. **Install optional tools:**

   ```bash
   # StyLua (Lua formatter)
   cargo install stylua

   # luacheck (Lua linter)
   luarocks install luacheck
   ```

## Usage

### Automatic (On Commit)

Once installed, pre-commit hooks run automatically when you commit:

```bash
git commit -m "your message"
```

If checks fail:

1. Fix the reported issues
1. Stage the fixes: `git add .`
1. Commit again

### Manual (Anytime)

Run checks manually on all files:

```bash
pre-commit run --all-files
# or
make pre-commit
```

Run specific checks:

```bash
# Format code
make format

# Lint code
make lint

# Check syntax
make syntax-check

# All checks
make check
```

## What Gets Checked

### 1. **File Hygiene**

- Trailing whitespace removal
- End-of-file newline
- YAML syntax
- Large file detection
- Merge conflict detection

### 2. **Lua Formatting (StyLua)**

- Automatic code formatting
- Based on `stylua.toml` config
- Enforces consistent style

### 3. **Lua Linting (luacheck)**

- Static analysis
- Detects undefined variables
- Finds unused variables
- Based on `.luacheckrc` config

### 4. **Syntax Check**

- Validates Lua syntax with `luac`
- Catches syntax errors early

### 5. **Markdown Formatting (optional)**

- Formats markdown files
- Ensures consistent documentation

## Configuration Files

### `.pre-commit-config.yaml`

Main pre-commit configuration defining all hooks.

### `.luacheckrc`

Luacheck configuration:

- Defines global variables (like `vim`)
- Ignores specific warnings
- Sets line length limits

### `stylua.toml`

StyLua formatting rules:

- Column width: 100
- Indent: 2 spaces
- Quote style: Auto (prefer double)

### `.editorconfig`

Editor configuration for consistent formatting across editors.

### `Makefile`

Convenient commands for running checks.

## Troubleshooting

### "pre-commit: command not found"

Install pre-commit:

```bash
pip3 install --user pre-commit
```

Make sure `~/.local/bin` is in your PATH.

### "stylua: command not found"

Install StyLua:

```bash
# Using cargo
cargo install stylua

# Using Homebrew (macOS)
brew install stylua

# Download binary from GitHub
# https://github.com/JohnnyMorganz/StyLua/releases
```

### "luacheck: command not found"

Install luacheck:

```bash
# Using LuaRocks
luarocks install luacheck

# On Ubuntu/Debian
sudo apt-get install luarocks
sudo luarocks install luacheck

# On macOS
brew install luarocks
luarocks install luacheck
```

### Pre-commit is too slow

You can skip hooks temporarily:

```bash
git commit --no-verify
```

**Note:** Only use this when necessary!

### Update hooks to latest versions

```bash
pre-commit autoupdate
# or
make update-hooks
```

## Skipping Specific Hooks

Skip a specific hook for one commit:

```bash
SKIP=stylua git commit -m "message"
```

Skip all hooks for one commit:

```bash
git commit --no-verify -m "message"
```

## CI/CD Integration

Pre-commit checks also run in CI/CD (GitHub Actions):

- See `.github/workflows/ci.yml`
- All PRs must pass checks
- Helps catch issues before merge

## Best Practices

1. **Run checks before committing:**

   ```bash
   make check
   ```

1. **Format code regularly:**

   ```bash
   make format
   ```

1. **Fix lint issues promptly:**

   ```bash
   make lint
   ```

1. **Keep hooks updated:**

   ```bash
   make update-hooks
   ```

1. **Don't skip checks without good reason**

## Available Make Commands

```bash
make help           # Show all commands
make install        # Install pre-commit hooks
make format         # Format code with StyLua
make lint           # Lint with luacheck
make syntax-check   # Check Lua syntax
make check          # Run all checks
make pre-commit     # Run pre-commit on all files
make clean          # Clean generated files
make update-hooks   # Update hooks to latest
```

## More Information

- **Full Development Guide:** See [DEVELOPMENT.md](DEVELOPMENT.md)
- **Contributing:** See [CONTRIBUTING.md](CONTRIBUTING.md)
- **Pre-commit Docs:** https://pre-commit.com

______________________________________________________________________

Questions? Open an issue or check the development guide!
