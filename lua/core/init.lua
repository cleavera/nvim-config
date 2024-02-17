local M = {}

M.setup = function()
  require("core.options")
  require("core.startup")
  require("plugins")
  require("keymaps")
  require("core.commands")
end

return M

