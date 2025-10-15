-- Tracker module for automatically saving Telescope searches
local db = require("telescope-history.db")
local config = require("telescope-history.config")

local M = {}

-- Track whether we've already hooked into Telescope
local hooked = false

-- Store original Telescope builtin functions
local original_functions = {}

-- Wrapper function to track searches
local function wrap_search_function(fn_name, original_fn)
  return function(opts)
    opts = opts or {}
    
    -- Get the project path
    local project_path = vim.loop.cwd()
    
    -- Store the original attach_mappings if it exists
    local original_attach_mappings = opts.attach_mappings
    
    -- Override attach_mappings to capture the search term
    opts.attach_mappings = function(prompt_bufnr, map)
      -- Get the original behavior
      local should_continue = true
      if original_attach_mappings then
        should_continue = original_attach_mappings(prompt_bufnr, map)
      end
      
      -- Hook into the prompt to get the search term when user presses enter
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      
      -- Wrap the select_default action
      local original_select = actions.select_default
      actions.select_default:replace(function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local search_term = picker:_get_prompt()
        
        -- Save to database if auto_save is enabled
        local cfg = config.get()
        if cfg.auto_save and search_term and search_term ~= "" then
          -- Check if search term matches any ignore patterns
          local should_ignore = false
          for _, pattern in ipairs(cfg.ignore_patterns) do
            if search_term:match(pattern) then
              should_ignore = true
              break
            end
          end
          
          if not should_ignore then
            db.add_search(search_term, fn_name, project_path)
          end
        end
        
        -- Call the original action
        original_select(prompt_bufnr)
      end)
      
      return should_continue
    end
    
    -- For grep_string, capture the search parameter directly
    if fn_name == "grep_string" and opts.search then
      local cfg = config.get()
      if cfg.auto_save then
        db.add_search(opts.search, fn_name, project_path)
      end
    end
    
    -- Call the original function
    return original_fn(opts)
  end
end

-- Hook into Telescope builtin functions
function M.setup_hooks()
  if hooked then
    return
  end
  
  local cfg = config.get()
  if not cfg.auto_save then
    return
  end
  
  local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
  if not has_telescope then
    vim.notify("Telescope not found, cannot setup history tracking", vim.log.levels.WARN)
    return
  end
  
  -- Hook into the configured search types
  for _, search_type in ipairs(cfg.track_types) do
    if telescope_builtin[search_type] then
      -- Save original function
      original_functions[search_type] = telescope_builtin[search_type]
      
      -- Replace with wrapped version
      telescope_builtin[search_type] = wrap_search_function(search_type, original_functions[search_type])
    end
  end
  
  hooked = true
end

-- Manually save a search (for when auto_save is disabled)
function M.save_search(search_term, search_type)
  local project_path = vim.loop.cwd()
  db.add_search(search_term, search_type, project_path)
end

return M

