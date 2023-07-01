local M = {}

M.setup = function()
  require("core.options")
  require("keymaps.movement")
  require("lazy")

  vim.cmd.colorscheme "catppuccin"
end

return M

