-- Database module for storing and retrieving search history
local config = require("telescope-history.config")

local M = {}

-- Get the SQLite database path
local function get_db_path()
  local data_path = vim.fn.stdpath("data")
  return data_path .. "/telescope_history.db"
end

-- Initialize SQLite connection
local function get_db()
  local sqlite = require("sqlite.db")
  local db_path = get_db_path()
  
  local db = sqlite({
    uri = db_path,
    search_history = {
      id = { "integer", "primary", "key" },
      search_term = "text",
      search_type = "text",
      project_path = "text",
      timestamp = { "text", default = "CURRENT_TIMESTAMP" },
    },
  })
  
  return db
end

-- Add a search to the history
function M.add_search(search_term, search_type, project_path)
  if not search_term or search_term == "" then
    return
  end
  
  local cfg = config.get()
  
  -- Check if we should track this search type
  if not vim.tbl_contains(cfg.track_types, search_type) then
    return
  end
  
  local db = get_db()
  
  -- Insert the new search
  db.search_history:insert({
    search_term = search_term,
    search_type = search_type,
    project_path = project_path,
    timestamp = os.date("%Y-%m-%d %H:%M:%S"),
  })
  
  -- Clean up old entries if we exceed max_entries
  M.cleanup_old_entries(project_path)
end

-- Get search history for a project
function M.get_history(project_path, limit)
  local db = get_db()
  limit = limit or 100
  
  local cfg = config.get()
  
  -- Query based on scope
  local where_clause = {}
  if cfg.scope == "project" then
    where_clause = { where = { project_path = project_path } }
  elseif cfg.scope == "global" then
    -- No filter, get all
    where_clause = {}
  end
  
  -- Get entries ordered by timestamp
  local entries = db.search_history:get({
    where = where_clause.where,
    order_by = { desc = "timestamp" },
    limit = limit,
  })
  
  return entries or {}
end

-- Delete a specific entry
function M.delete_entry(entry_id)
  local db = get_db()
  db.search_history:remove({ where = { id = entry_id } })
end

-- Clean up old entries to maintain max_entries limit
function M.cleanup_old_entries(project_path)
  local cfg = config.get()
  local max_entries = cfg.max_entries or 1000
  
  local db = get_db()
  
  -- Count current entries for this project
  local entries
  if cfg.scope == "project" then
    entries = db.search_history:get({
      where = { project_path = project_path },
      order_by = { desc = "timestamp" },
    })
  else
    entries = db.search_history:get({
      order_by = { desc = "timestamp" },
    })
  end
  
  if #entries > max_entries then
    -- Delete the oldest entries
    local to_delete = #entries - max_entries
    for i = #entries - to_delete + 1, #entries do
      M.delete_entry(entries[i].id)
    end
  end
end

-- Clear all history for a project
function M.clear_project_history(project_path)
  local db = get_db()
  db.search_history:remove({ where = { project_path = project_path } })
end

-- Clear all history
function M.clear_all_history()
  local db = get_db()
  db.search_history:remove({})
end

-- Get statistics
function M.get_stats()
  local db = get_db()
  local all_entries = db.search_history:get({})
  
  local stats = {
    total_searches = #all_entries,
    projects = {},
    search_types = {},
  }
  
  for _, entry in ipairs(all_entries) do
    -- Count by project
    stats.projects[entry.project_path] = (stats.projects[entry.project_path] or 0) + 1
    -- Count by type
    stats.search_types[entry.search_type] = (stats.search_types[entry.search_type] or 0) + 1
  end
  
  return stats
end

return M

