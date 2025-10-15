-- Example configuration for better-telescope-history
-- Copy this to your Neovim config and adjust to your preferences

-- Basic setup with defaults
require("telescope-history").setup()
require("telescope").load_extension("history")

-- Or with custom configuration:
-- require("telescope-history").setup({
--   -- Track history per project (default) or globally
--   scope = "project",  -- Options: "project" | "global"
--   
--   -- Maximum number of searches to store
--   max_entries = 1000,
--   
--   -- Maximum results to show in the picker
--   max_results = 100,
--   
--   -- Which Telescope search types to track
--   track_types = {
--     "live_grep",
--     "grep_string",
--     "find_files",
--     -- Add more if needed:
--     -- "buffers",
--     -- "help_tags",
--     -- "oldfiles",
--   },
--   
--   -- Automatically save searches (recommended)
--   auto_save = true,
--   
--   -- Ignore certain search patterns (Lua patterns)
--   ignore_patterns = {
--     -- Examples:
--     -- "^test",        -- Don't save searches starting with "test"
--     -- "%.tmp$",       -- Don't save searches ending with ".tmp"
--     -- "password",     -- Don't save searches containing "password"
--     -- "secret",       -- Don't save searches containing "secret"
--   },
-- })

-- Recommended keybindings
vim.keymap.set("n", "<leader>fh", "<cmd>TelescopeHistory<cr>", {
  desc = "Search History",
})

-- Alternative keybindings you might like:
-- vim.keymap.set("n", "<leader>sh", "<cmd>TelescopeHistory<cr>", { desc = "Search History" })
-- vim.keymap.set("n", "<C-h>", "<cmd>TelescopeHistory<cr>", { desc = "Search History" })

-- Additional command keybindings (optional)
vim.keymap.set("n", "<leader>fhc", "<cmd>TelescopeHistoryClear<cr>", {
  desc = "Clear Project Search History",
})

vim.keymap.set("n", "<leader>fhs", "<cmd>TelescopeHistoryStats<cr>", {
  desc = "Search History Statistics",
})

-- Example: Global history for all projects
-- require("telescope-history").setup({
--   scope = "global",
--   max_results = 200,
-- })

-- Example: Track more search types
-- require("telescope-history").setup({
--   track_types = {
--     "live_grep",
--     "grep_string",
--     "find_files",
--     "buffers",
--     "help_tags",
--     "oldfiles",
--     "git_files",
--     "current_buffer_fuzzy_find",
--   },
-- })

-- Example: Manual save mode (disable auto_save)
-- require("telescope-history").setup({
--   auto_save = false,
-- })
-- -- Then manually save when needed:
-- vim.keymap.set("n", "<leader>hs", function()
--   local term = vim.fn.input("Search term to save: ")
--   local type = vim.fn.input("Search type (live_grep/find_files): ", "live_grep")
--   require("telescope-history").tracker.save_search(term, type)
-- end, { desc = "Manually Save Search" })

