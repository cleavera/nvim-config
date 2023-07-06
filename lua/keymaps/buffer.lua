local which_key = require("which-key")
which_key.register({
  ["<leader>b"] = { name = "Buffer" }
})

vim.keymap.set('n', '<leader>bc', function()
  vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), {})
end, { desc = "Close" })
