local which_key = require("which-key")
which_key.add({
  {"<leader>t", group = "Terminal" }
})

local fterm = require('FTerm')

vim.keymap.set('n', '<leader>tf', function()
  fterm.open()
end, { desc = "Open" })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Esc>', function ()
  fterm.close()
end, { desc = "Toggle terminal" })

vim.keymap.set('n', '<leader>ts', function()
  local cmd = vim.fn.input('Command: ')
  fterm.scratch({ cmd = cmd })
end, { desc = "Scratch" })

vim.api.nvim_create_autocmd('DirChanged', {
  pattern = {
    '*'
  },
  callback = function()
    fterm.open()
    fterm.exit()
  end,
})
