local which_key = require("which-key")
local api = require("plugins.terminal.api")
which_key.register({
  ["<leader>t"] = { name = "Terminal" }
})

local fterm = require('FTerm')

vim.keymap.set('n', '<leader>tf', function()
  fterm.open()
end, { desc = "Open" })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Esc>', function ()
  api.close()
end, { desc = "Toggle terminal" })

vim.keymap.set('n', '<leader>ts', function()
  local cmd = vim.fn.input('Command: ')
  fterm.scratch({ cmd = cmd })
end, { desc = "Scratch" })

vim.keymap.set('n', '<leader>tr', function()
  api.terminals.run:open()
end, { desc = "Run" })

vim.keymap.set('n', '<leader>tt', function()
  api.terminals.test:open()
end, { desc = "Test" })

vim.keymap.set('n', '<leader>g', function()
  api.terminals.git:open()
end, { desc = "Git" })

vim.api.nvim_create_autocmd('DirChanged', {
  pattern = {
    '*'
  },
  callback = function()
    local fterm = require('FTerm')
    fterm.open()
    fterm.exit()
    api.terminals.test:open()
    api.terminals.test:close(true)
    api.terminals.run:open()
    api.terminals.run:close(true)
    api.terminals.git:open()
    api.terminals.git:close(true)
  end,
})
