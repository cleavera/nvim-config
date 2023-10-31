local M = {}

function M:setup()
  vim.api.nvim_create_autocmd('DirChanged', {
    pattern = {
      '*'
    },
    callback = function()
      require('plugins.project.api'):add_recent(vim.fn.getcwd())
      local explorer = require('nvim-tree.api')
      explorer.tree.change_root(vim.fn.getcwd())
      explorer.tree.open()
      local fterm = require('FTerm')
      fterm.open()
      fterm.exit()
    end,
  })
end

return M
