local api = require('Comment.api')

vim.keymap.set('n', '<c-_>', function() api.toggle.linewise.current() end, { desc = "Comment" })
vim.keymap.set('i', '<c-_>', function() api.toggle.linewise.current() end, { desc = "Comment" })
vim.keymap.set('v', '<c-_>', function() api.toggle.linewise.current() end, { desc = "Comment" })
