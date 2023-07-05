local which_key = require("which-key")
which_key.register({
  ["<leader>g"] = { name = "Git" }
})

vim.keymap.set('n', '<leader>gs', "<cmd>Git<cr>", { desc = "Git summary" })
