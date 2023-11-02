local M = {}

local function branch_name()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
	branch = branch:gsub("%s", "")
	if branch ~= "" then
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
      require('plugins.project.api'):add_recent(vim.fn.getcwd())
      local explorer = require('nvim-tree.api')
      explorer.tree.change_root(vim.fn.getcwd())
      local fterm = require('FTerm')
      fterm.open()
      fterm.exit()
      explorer.tree.open()
      local branch = branch_name()
      local project = {
        name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
        branch = branch,
        is_git_project = branch ~= ''
      }
      vim.g.project = project
    end,
  })
end

return M
