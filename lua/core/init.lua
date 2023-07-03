local M = {}

M.setup = function()
  require("core.options")
  require("core.startup")
  require("plugins")
  require("keymaps")

  vim.cmd.colorscheme "catppuccin"
end

return M

