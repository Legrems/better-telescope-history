-- Luacheck configuration for better-telescope-history

-- Neovim standard library (use luajit, not luajit+vim)
std = "luajit"

-- Read-only globals from Neovim
read_globals = {
  "vim",
}

-- Ignore certain warnings
ignore = {
  "212", -- Unused argument (common in callback functions)
  "213", -- Unused loop variable
  "631", -- Line is too long (we have stylua for formatting)
}

-- Exclude certain paths
exclude_files = {
  ".git/",
  ".github/",
  "doc/",
}

-- Maximum line length (we use stylua for this, but set a reasonable limit)
max_line_length = 120

-- Maximum cyclomatic complexity
max_cyclomatic_complexity = 15

-- Maximum code nesting depth
max_code_line_length = 120
