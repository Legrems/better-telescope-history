-- Main initialization module for telescope-history
local M = {}

local config = require("telescope-history.config")
local tracker = require("telescope-history.tracker")
local db = require("telescope-history.db")

-- Setup function to initialize the plugin
function M.setup(user_config)
  -- Setup configuration
  config.setup(user_config)
  
  -- Setup tracking hooks
  tracker.setup_hooks()
  
  -- Create user commands
  vim.api.nvim_create_user_command("TelescopeHistory", function()
    require("telescope").extensions.history.history()
  end, { desc = "Open Telescope search history picker" })
  
  vim.api.nvim_create_user_command("TelescopeHistoryClear", function()
    local project_path = vim.loop.cwd()
    db.clear_project_history(project_path)
    vim.notify("Cleared Telescope history for current project", vim.log.levels.INFO)
  end, { desc = "Clear Telescope search history for current project" })
  
  vim.api.nvim_create_user_command("TelescopeHistoryClearAll", function()
    vim.ui.input({
      prompt = "Are you sure you want to clear ALL history? (y/n): ",
    }, function(input)
      if input and input:lower() == "y" then
        db.clear_all_history()
        vim.notify("Cleared all Telescope history", vim.log.levels.INFO)
      end
    end)
  end, { desc = "Clear all Telescope search history" })
  
  vim.api.nvim_create_user_command("TelescopeHistoryStats", function()
    local stats = db.get_stats()
    local lines = {
      "Telescope Search History Statistics:",
      "",
      "Total Searches: " .. stats.total_searches,
      "",
      "Searches by Project:",
    }
    
    for project, count in pairs(stats.projects) do
      table.insert(lines, "  " .. project .. ": " .. count)
    end
    
    table.insert(lines, "")
    table.insert(lines, "Searches by Type:")
    
    for search_type, count in pairs(stats.search_types) do
      table.insert(lines, "  " .. search_type .. ": " .. count)
    end
    
    -- Display in a floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    
    local width = 60
    local height = #lines + 2
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = (vim.o.columns - width) / 2,
      row = (vim.o.lines - height) / 2,
      style = "minimal",
      border = "rounded",
      title = " Statistics ",
      title_pos = "center",
    })
    
    -- Close on q or escape
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
  end, { desc = "Show Telescope search history statistics" })
end

-- Export modules for direct access if needed
M.config = config
M.db = db
M.tracker = tracker

return M

