local which_key = require("which-key")
which_key.register({
  ["<leader>p"] = { name = "Project" }
})

local picker = require('plugins.project.picker')

vim.keymap.set('n', '<leader>pr', function()
  picker:recent_projects_picker()
end, { desc = "Recent" })

vim.keymap.set('n', '<leader>pa', function()
  picker:all_projects_picker('c:\\www')
end, { desc = "All projects" })

vim.keymap.set('n', '<leader>pc', function()
  require('plugins.project.api'):config()
end, { desc = "Config" })
