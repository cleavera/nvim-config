vim.keymap.set("n", "<leader>e", function()
  local api = require("nvim-tree.api")

  if vim.bo.filetype == "NvimTree" then
    vim.cmd.wincmd "p"
  else
    api.tree.open({ find_file = true })
  end
end, { desc = "Focus explorer" })
