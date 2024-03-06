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

        vim.api.nvim_buf_set_keymap(bufnr, "n", "<a-x>", "<cmd>NvimTreeClose<cr>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<Left>", "<cmd>lua require('nvim-tree.api').node.navigate.parent_close()<cr>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<S-Left>", "<cmd>lua require('nvim-tree.api').node.navigate.parent()<cr>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<Right>", "<cmd>lua if require('nvim-tree.api').tree.get_node_under_cursor().name == '..' then vim.api.nvim_feedkeys('j', 'n', false) elseif (require('nvim-tree.api').tree.get_node_under_cursor().fs_stat.type == 'directory' and (not require('nvim-tree.api').tree.get_node_under_cursor().open)) then require('nvim-tree.api').node.open.edit() vim.api.nvim_feedkeys('j', 'n', false) end<cr>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<S-Right>", "<cmd>lua if require('nvim-tree.api').tree.get_node_under_cursor().name == '..' then vim.api.nvim_feedkeys('j', 'n', false) elseif (require('nvim-tree.api').tree.get_node_under_cursor().fs_stat.type == 'directory' and (not require('nvim-tree.api').tree.get_node_under_cursor().open)) then require('nvim-tree.api').node.open.edit() vim.api.nvim_feedkeys('j', 'n', false) end<cr>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<S-Down>", "<cmd>lua if require('nvim-tree.api').tree.get_node_under_cursor().fs_stat.type == 'file' then require('nvim-tree.api').node.navigate.parent() end require('nvim-tree.api').node.navigate.sibling.next()<cr>", {})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<S-Up>", "<cmd>lua if require('nvim-tree.api').tree.get_node_under_cursor().fs_stat.type == 'file' then require('nvim-tree.api').node.navigate.parent() end require('nvim-tree.api').node.navigate.sibling.prev()<cr>", {})
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
