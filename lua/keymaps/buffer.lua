local which_key = require("which-key")
which_key.register({
  ["<leader>b"] = { name = "Buffer" }
})

vim.keymap.set('n', '<leader>bc', function()
  vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), {})
end, { desc = "Close" })
vim.keymap.set('n', '<leader>bj', function()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local next_buf = nil

  for i, buf in ipairs(bufs) do
    if buf == current_buf then
      next_buf = bufs[i + 1]
    end
  end

  if next_buf ~= nil then
    vim.api.nvim_set_current_buf(next_buf)
  end
end, { desc = "Next" })
vim.keymap.set('n', '<leader>bk', function()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local next_buf = nil

  for i, buf in ipairs(bufs) do
    if buf == current_buf then
      next_buf = bufs[i - 1]
    end
  end

  if next_buf ~= nil then
    vim.api.nvim_set_current_buf(next_buf)
  end
end, { desc = "Previous" })
