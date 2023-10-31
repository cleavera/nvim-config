local which_key = require("which-key")
which_key.register({
  ["<leader>t"] = { name = "Terminal" }
})

local fterm = require('FTerm')

vim.keymap.set('n', '<leader>tf', function()
  fterm.open()
end, { desc = "Open" })

vim.keymap.set('t', '<esc>', function ()
  fterm.close()
end, { desc = "Toggle terminal" })

vim.keymap.set('n', '<esc>', function ()
  fterm.close()
end, { desc = "Toggle terminal" })

vim.keymap.set('n', '<F7>', function()
  fterm.open()
end, { desc = "Open" })
