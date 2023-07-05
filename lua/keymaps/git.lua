local which_key = require("which-key")
which_key.register({
  ["<leader>g"] = { name = "Git" }
})

local Git = {}

function Git:get_buf()
  if self.buf == nil then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'GitDiff')

    self.buf = buf
  end

  return self.buf
end

function Git:create_win(buf)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    style = 'minimal',
    width = 80,
    height = 20,
    col = 20,
    row = 20,
  })

  return win
end

function Git:summary()
  local b = self:get_buf()
  self:create_win(b)
end

vim.keymap.set('n', '<leader>gs', "<cmd>Git<cr>", { desc = "Summary" })
vim.keymap.set('n', '<leader>gp', "<cmd>Git pull origin --rebase<cr>", { desc = "Pull" })
vim.keymap.set('n', '<leader>gb', function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
vim.keymap.set('n', '<leader>gd', function() require("gitsigns").diffthis() end, { desc = "Diff file" })

--vim.keymap.set('n', '<leader>gt', function()
--  Git:summary()
--end, { desc = "Test" })
