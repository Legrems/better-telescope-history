-- Telescope History Extension
-- Main extension file that registers the history picker

local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local entry_display = require("telescope.pickers.entry_display")

local db = require("telescope-history.db")
local config = require("telescope-history.config")

local M = {}

-- Create the history picker
local function history_picker(opts)
  opts = opts or {}
  
  -- Get current project path
  local cwd = vim.loop.cwd()
  
  -- Get history from database
  local history_entries = db.get_history(cwd, opts.limit or config.get().max_results)
  
  if #history_entries == 0 then
    vim.notify("No search history found for this project", vim.log.levels.INFO)
    return
  end
  
  -- Create displayer for nice formatting
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 20 },
      { width = 15 },
      { remaining = true },
    },
  })
  
  local function make_display(entry)
    return displayer({
      { entry.timestamp, "TelescopeResultsComment" },
      { entry.search_type, "TelescopeResultsIdentifier" },
      { entry.search_term, "TelescopeResultsString" },
    })
  end
  
  pickers.new(opts, {
    prompt_title = "Search History",
    finder = finders.new_table({
      results = history_entries,
      entry_maker = function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry.search_term .. " " .. entry.search_type,
          timestamp = entry.timestamp,
          search_type = entry.search_type,
          search_term = entry.search_term,
          project_path = entry.project_path,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer({
      title = "Search Details",
      define_preview = function(self, entry)
        local lines = {
          "Search Term: " .. entry.search_term,
          "Type: " .. entry.search_type,
          "Project: " .. entry.project_path,
          "Timestamp: " .. entry.timestamp,
          "",
          "Press <CR> to repeat this search",
        }
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      end,
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        -- Re-execute the search based on type
        if selection then
          local search_term = selection.search_term
          local search_type = selection.search_type
          
          -- Execute the appropriate Telescope command
          if search_type == "live_grep" then
            require("telescope.builtin").live_grep({ default_text = search_term })
          elseif search_type == "grep_string" then
            require("telescope.builtin").grep_string({ search = search_term })
          elseif search_type == "find_files" then
            require("telescope.builtin").find_files({ default_text = search_term })
          else
            -- Generic fallback
            require("telescope.builtin").live_grep({ default_text = search_term })
          end
        end
      end)
      
      -- Add delete mapping
      map("i", "<C-d>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          db.delete_entry(selection.value.id)
          vim.notify("Deleted history entry", vim.log.levels.INFO)
          -- Refresh the picker
          actions.close(prompt_bufnr)
          history_picker(opts)
        end
      end)
      
      return true
    end,
  }):find()
end

-- Register the extension
return telescope.register_extension({
  setup = function(ext_config)
    config.setup(ext_config)
  end,
  exports = {
    history = history_picker,
  },
})

