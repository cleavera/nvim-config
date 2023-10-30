local which_key = require("which-key")
which_key.register({
  ["<leader>b"] = { name = "Buffer" }
})

local function get_bufs()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_get_option(bufnr, "buflisted") and vim.api.nvim_buf_is_valid(bufnr)
  end, vim.api.nvim_list_bufs())
end

vim.keymap.set('n', '<leader>bc', function()
  vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), {})
end, { desc = "Close" })

vim.keymap.set('n', '<leader>bC', function()
  vim.cmd('bufdo bwipeout')
end, { desc = "Close all" })

vim.keymap.set('n', '<leader>bs', function()
  vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(false, true))
end, { desc = "Scratch buffer" })

vim.keymap.set('n', '<leader>bj', function()
  local bufs = get_bufs()
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
  local bufs = get_bufs()
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

vim.keymap.set('n', '<leader>bs', function()
  vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(false, true))
end, { desc = "Scratch" })

vim.keymap.set('n', '<C-s>', '<cmd>wa<cr>')
vim.keymap.set('i', '<C-s>', '<cmd>wa<cr>')
vim.keymap.set('v', '<C-s>', '<cmd>wa<cr>')
