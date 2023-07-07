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

local telescope = require("telescope.builtin")

-- vim.keymap.set('n', '<leader>gs', "<cmd>Git<cr>", { desc = "Summary" })
vim.keymap.set('n', '<leader>gs', function () telescope.git_status() end, { desc = "Summary" })
vim.keymap.set('n', '<leader>gu', "<cmd>Git pull origin --rebase<cr>", { desc = "Pull" })
vim.keymap.set('n', '<leader>gp', "<cmd>Git push origin<cr>", { desc = "Push" })
vim.keymap.set('n', '<leader>gb', function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
vim.keymap.set('n', '<leader>gd', function() require("gitsigns").diffthis() end, { desc = "Diff file" })
vim.keymap.set('n', '<leader>gc', function() telescope.git_commits() end, { desc = "Commits" })
vim.keymap.set('n', '<leader>gC', function() telescope.git_bcommits() end, { desc = "File commits" })
vim.keymap.set('n', '<leader>gB', function() telescope.git_branches() end, { desc = "Branches" })
vim.keymap.set('n', '<leader>gS', function() telescope.git_stash() end, { desc = "Stashes" })

--vim.keymap.set('n', '<leader>gt', function()
--  Git:summary()
--end, { desc = "Test" })
