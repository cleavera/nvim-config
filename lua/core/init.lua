local M = {}

M.setup = function()
  require("core.options")
  require("keymaps")
  require("plugins")

  vim.cmd.colorscheme "catppuccin"
end

return M

