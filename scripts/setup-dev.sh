#!/usr/bin/env bash
# Setup script for better-telescope-history development environment

set -e

echo "🚀 Setting up better-telescope-history development environment..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for required tools
echo "📋 Checking required tools..."

# Check Python/pip
if command_exists python3 || command_exists python; then
  echo -e "${GREEN}✓${NC} Python found"
else
  echo -e "${RED}✗${NC} Python not found"
  exit 1
fi

# Check pip
if command_exists pip3 || command_exists pip; then
  echo -e "${GREEN}✓${NC} pip found"
  PIP_CMD=$(command_exists pip3 && echo "pip3" || echo "pip")
else
  echo -e "${RED}✗${NC} pip not found"
  exit 1
fi

# Check Git
if command_exists git; then
  echo -e "${GREEN}✓${NC} Git found"
else
  echo -e "${RED}✗${NC} Git not found - please install Git"
  exit 1
fi

echo ""
echo "📦 Installing development tools..."

# Install pre-commit
if command_exists pre-commit; then
  echo -e "${GREEN}✓${NC} pre-commit already installed"
else
  echo "Installing pre-commit..."
  $PIP_CMD install --user pre-commit
  echo -e "${GREEN}✓${NC} pre-commit installed"
fi

# Check for StyLua
if command_exists stylua; then
  echo -e "${GREEN}✓${NC} StyLua already installed"
else
  echo -e "${YELLOW}⚠${NC} StyLua not found"
  echo "   Please install StyLua manually:"
  echo "   - Cargo: cargo install stylua"
  echo "   - Download: https://github.com/JohnnyMorganz/StyLua/releases"
  echo "   - Homebrew: brew install stylua"
fi

# Check for luacheck
if command_exists luacheck; then
  echo -e "${GREEN}✓${NC} luacheck already installed"
else
  echo -e "${YELLOW}⚠${NC} luacheck not found"
  echo "   Please install luacheck manually:"
  echo "   - LuaRocks: luarocks install luacheck"
  echo "   - Homebrew: brew install luarocks && luarocks install luacheck"
fi

# Check for luac
if command_exists luac; then
  echo -e "${GREEN}✓${NC} luac found"
else
  echo -e "${YELLOW}⚠${NC} luac not found - please install Lua"
fi

echo ""
echo "🔧 Installing pre-commit hooks..."
pre-commit install
echo -e "${GREEN}✓${NC} Pre-commit hooks installed"

echo ""
echo "✨ Development environment setup complete!"
echo ""
echo "Available commands:"
echo "  make help        - Show all available commands"
echo "  make format      - Format code with StyLua"
echo "  make lint        - Lint code with luacheck"
echo "  make check       - Run all checks"
echo "  make pre-commit  - Run pre-commit on all files"
echo ""
echo "For more information, see DEVELOPMENT.md"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
