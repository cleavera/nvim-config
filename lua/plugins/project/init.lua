local M = {}
local api = require('plugins.project.api')

local function string_starts(str, start)
   return string.sub(str, 1, string.len(start)) == start
end

local function branch_name()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
	branch = branch:gsub("%s", "")
	if branch ~= "" and not string_starts(branch, "fatal") then
		return branch
	else
		return ""
	end
end

function M:setup()
  vim.api.nvim_create_autocmd('DirChanged', {
    pattern = {
      '*'
    },
    callback = function()
      api:add_recent(vim.fn.getcwd())
      local explorer = require('nvim-tree.api')
      explorer.tree.change_root(vim.fn.getcwd())
      explorer.tree.open()
      local branch = branch_name()
      local project = {
        name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
        branch = branch,
        is_git_project = branch ~= '',
        project_type = api:get_project_type()
      }
      vim.g.project = project

      if project.project_type == api.project_type.RUST then
        vim.cmd.colorscheme('catppuccin-latte')
      end

      if project.project_type == api.project_type.NODE then
        vim.cmd.colorscheme('catppuccin-frappe')
      end

      if project.project_type == api.project_type.CSHARP then
        vim.cmd.colorscheme('catppuccin-macchiato')
      end

      if project.project_type == api.project_type.UNKNOWN then
        vim.cmd.colorscheme('catppuccin-mocha')
      end
    end
  })
end

return M
