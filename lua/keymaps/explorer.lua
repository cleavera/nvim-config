vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
vim.keymap.set("n", "<leader>o", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd.wincmd "p"
  else
    vim.cmd.NvimTreeFocus()
  end
end)
