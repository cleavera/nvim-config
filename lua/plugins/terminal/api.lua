local fterm = require('FTerm')

local M = {} 

local terminals = {
  test = fterm:new({
    cmd = "powershell"
  }),
  run = fterm:new({
    cmd = "powershell"
  }),
  git = fterm:new({
    cmd = "gitui"
  })
}

M.terminals = terminals

M.close = function()
  terminals.test:close()
  terminals.run:close()
  terminals.git:close()
  fterm.close()
end

return M
