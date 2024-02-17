local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local dropdown = require('telescope.themes').get_dropdown({})
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local entry_display = require('telescope.pickers.entry_display')

local M = {}

local function get_project_name(path)
  return vim.fn.fnamemodify(path, ":t")
end

function M:open_picker(source)
  local opts = {
    prompt_title = "Projects",
    sorter = sorters.get_fzy_sorter({}),
    finder = finders.new_table({
      results = source,
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = " ",
          items = {
            {},
            { remaining = true },
          },
        });

        return {
          value = entry,
          ordinal = entry,
          display = function(entry)
            return displayer {
              { get_project_name(entry.value), "TelescopeResultsIdentifier" },
              { entry.value, "NonText" }
            }
          end
        }
      end
    }),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        vim.fn.chdir(selection.value)
        vim.cmd("bufdo bwipeout")
      end)

      return true
    end
  }

  local projects = pickers.new(opts, dropdown)

  projects:find()
end

function M:all_projects_picker(project_root)
  self:open_picker(require('plugins.project.api'):list(project_root))
end

function M:recent_projects_picker()
  self:open_picker(require('plugins.project.api'):list_recent())
end

return M
