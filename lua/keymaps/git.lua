local which_key = require("which-key")
which_key.register({
  ["<leader>g"] = { name = "Git" }
})


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

vim.keymap.set('n', '<leader>gt', function()
 require('plugins.git.summary'):open()
end, { desc = "Test" })
