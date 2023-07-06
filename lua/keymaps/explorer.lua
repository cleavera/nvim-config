vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle explorer" })
vim.keymap.set("n", "<leader>o", function()
  local api = require("nvim-tree.api")

  if vim.bo.filetype == "NvimTree" then
    vim.cmd.wincmd "p"
  else
    api.tree.open({ find_file = true })
  end
end, { desc = "Focus explorer" })
