-- Configuration module for telescope-history

local M = {}

-- Default configuration
local default_config = {
  -- Scope of history: "project" (per project) or "global" (all projects)
  scope = "project",
  
  -- Maximum number of entries to store per project
  max_entries = 1000,
  
  -- Maximum number of results to show in picker
  max_results = 100,
  
  -- Search types to track
  track_types = {
    "live_grep",
    "grep_string",
    "find_files",
  },
  
  -- Auto-save searches (automatically track searches)
  auto_save = true,
  
  -- Ignore patterns (don't save searches matching these patterns)
  ignore_patterns = {},
}

-- Current configuration
local current_config = vim.deepcopy(default_config)

-- Setup function to merge user config with defaults
function M.setup(user_config)
  current_config = vim.tbl_deep_extend("force", default_config, user_config or {})
end

-- Get current configuration
function M.get()
  return current_config
end

return M

