-- Test setup for better-telescope-history
-- Use this to quickly test the plugin in an isolated environment
--
-- Run with: nvim -u examples/test_setup.lua

-- Set up paths
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up lazy.nvim with test configuration
require("lazy").setup({
  -- Required dependencies
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "kkharji/sqlite.lua",
  },
  
  -- The plugin (local development version)
  {
    name = "better-telescope-history",
    dir = ".",  -- Current directory
    config = function()
      -- Test configuration
      require("telescope-history").setup({
        scope = "project",
        max_entries = 100,
        max_results = 50,
        track_types = {
          "live_grep",
          "grep_string",
          "find_files",
        },
        auto_save = true,
        ignore_patterns = {},
      })
      
      -- Load the extension
      require("telescope").load_extension("history")
      
      print("✓ Better Telescope History loaded successfully!")
      print("Try:")
      print("  :Telescope live_grep")
      print("  :Telescope find_files")
      print("  :TelescopeHistory")
    end,
  },
})

-- Set up basic keybindings for testing
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fh", "<cmd>TelescopeHistory<cr>", { desc = "Search History" })
vim.keymap.set("n", "<leader>fs", "<cmd>TelescopeHistoryStats<cr>", { desc = "History Stats" })
vim.keymap.set("n", "<leader>fc", "<cmd>TelescopeHistoryClear<cr>", { desc = "Clear History" })

-- Helpful commands
vim.api.nvim_create_user_command("TestHistory", function()
  print("Testing search history...")
  print("Current project: " .. vim.loop.cwd())
  
  local db = require("telescope-history.db")
  local history = db.get_history(vim.loop.cwd(), 10)
  
  print("Found " .. #history .. " history entries")
  for i, entry in ipairs(history) do
    print(string.format("  %d. [%s] %s", i, entry.search_type, entry.search_term))
  end
end, {})

-- Set some nice defaults for testing
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

print("\n=== Test Environment Ready ===")
print("Keybindings:")
print("  <leader>ff - Find files")
print("  <leader>fg - Live grep")
print("  <leader>fh - Search history")
print("  <leader>fs - History stats")
print("  <leader>fc - Clear history")
print("\nCommands:")
print("  :TestHistory - Show current history")
print("  :TelescopeHistory - Open history picker")
print("===============================\n")

