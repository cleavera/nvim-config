vim.api.nvim_create_user_command("TestDebug", function()
  require('FTerm').run({'npm run test-debug -- --code-coverage --include="'..vim.fn.expand('%:p')..'"'})
end, {})

