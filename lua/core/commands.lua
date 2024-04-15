vim.api.nvim_create_user_command("TestDebug", function()
  require('FTerm').run({'npm run test-debug -- --include="'..vim.fn.expand('%:p:~:.')..'"'})
end, {})

vim.api.nvim_create_user_command("Eslint", function()
  require('FTerm').run({'npx eslint '..vim.fn.expand('%:p:~:.')})
end, {})
