local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local dropdown = require('telescope.themes').get_dropdown({})
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

function M:open_picker(source)
  local opts = {
    prompt_title = "Projects",
    sorter = sorters.get_fzy_sorter({}),
    finder = finders.new_table(source),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        vim.fn.chdir(selection[1])
        vim.cmd.intro()
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
