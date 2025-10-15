# Makefile for better-telescope-history

.PHONY: help install format lint check test clean

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	pre-commit install
	@echo "✓ Pre-commit hooks installed"

format: ## Format all Lua files with StyLua
	@echo "Formatting Lua files..."
	stylua lua/ plugin/ examples/
	@echo "✓ Formatting complete"

lint: ## Lint all Lua files with luacheck
	@echo "Linting Lua files..."
	luacheck lua/ plugin/ examples/
	@echo "✓ Linting complete"

syntax-check: ## Check Lua syntax
	@echo "Checking Lua syntax..."
	@find lua plugin examples -name "*.lua" -exec luac -p {} \;
	@echo "✓ Syntax check complete"

check: syntax-check lint ## Run all checks (syntax + lint)
	@echo "✓ All checks passed"

pre-commit: ## Run pre-commit on all files
	@echo "Running pre-commit checks..."
	pre-commit run --all-files
	@echo "✓ Pre-commit checks complete"

clean: ## Clean up generated files
	@echo "Cleaning up..."
	@find . -name "*.db" -type f -delete
	@find . -name "*.log" -type f -delete
	@find . -name "*~" -type f -delete
	@echo "✓ Cleanup complete"

update-hooks: ## Update pre-commit hooks to latest versions
	@echo "Updating pre-commit hooks..."
	pre-commit autoupdate
	@echo "✓ Hooks updated"

test: ## Run tests (placeholder for future tests)
	@echo "No tests implemented yet"

.DEFAULT_GOAL := help
