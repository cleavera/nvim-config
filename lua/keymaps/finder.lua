local which_key = require("which-key")
which_key.register({
  ["<leader>f"] = { name = "Finder" }
})

local telescope = require("telescope.builtin")

vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = "Find file" })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = "Search files" })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = "Find buffer" })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = "Search help" })
vim.keymap.set('n', '<leader>fc', telescope.commands, { desc = "Commmands" })
vim.keymap.set('n', '<leader>fC', telescope.colorscheme, { desc = "Color schemes" })
