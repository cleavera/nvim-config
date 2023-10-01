local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.8  -- You can change this too

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      disable_netrw = true,
      hijack_netrw = true,
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      filters = {
        dotfiles = false,
        custom = { "\\.git" }
      },
      git = {
        enable = false
      },
      on_attach = function (bufnr)
        local api = require('nvim-tree.api')

        api.config.mappings.default_on_attach(bufnr)

        vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", "<cmd>NvimTreeClose<cr>", {})
      end,
      view = {
        relativenumber = true,
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()   

            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      }
    })
  end,
}
