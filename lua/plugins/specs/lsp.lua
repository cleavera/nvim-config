return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "folke/neodev.nvim"
    },
    build = ":MasonUpdate",
    config = function()
      local on_attach = function(_, buffer)
        local function map(...)
          vim.api.nvim_buf_set_keymap(buffer, ...)
        end

        vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

        map("n", "<leader>lh", function ()
          vim.lsp.buf.hover()
        end)
      end

      local function get_file_name(file)
        local file_name = file:match("[^/\\]*.lua$")
        return file_name:sub(0, #file_name - 4)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local server_names = {}
      local lsp_setups = {}

      local lsps = require("plenary.scandir").scan_dir("./lua/plugins/config/lsp", { add_dirs = false })
      for _,lsp in ipairs(lsps) do
        local l = require("plugins.config.lsp." .. get_file_name(lsp))
        table.insert(server_names, l.name)
        table.insert(lsp_setups, l.setup)
      end

      require("neodev").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = server_names
      })

      for _,setup in ipairs(lsp_setups) do
        setup()
      end
    end
  }
}
