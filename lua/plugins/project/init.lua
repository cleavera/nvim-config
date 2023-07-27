local M = {}

function M:setup()
  vim.api.nvim_create_autocmd('DirChanged', {
    pattern = {
      '*'
    },
    callback = function()
      require('plugins.project.api'):add_recent(vim.fn.getcwd())
    end,
  })
end

return M
