return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "folke/neodev.nvim"
      -- "github/copilot.vim"
    },
    build = ":MasonUpdate",
    config = function()
      local on_attach = function(_, buffer)
        local function remap_for_buffer(...)
          vim.api.nvim_buf_set_keymap(buffer, ...)
        end

        vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")
        remap_for_buffer("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Peek" })
        remap_for_buffer("n", "<leader>lg", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Goto definition" })
        remap_for_buffer("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format" })
        remap_for_buffer("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
        remap_for_buffer("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Diagnostics" })
        remap_for_buffer("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Action" })
      end

      local function get_file_name(file)
        local file_name = file:match("[^/\\]*.lua$")
        return file_name:sub(0, #file_name - 4)
      end

      local function script_path()
        local str = debug.getinfo(2, "S").source:sub(2)
        return str:match("(.*/)")
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local server_names = {}
      local lsp_setups = {}

      local lsps = require("plenary.scandir").scan_dir(script_path() .. "../config/lsp", { add_dirs = false })
      for _, lsp in ipairs(lsps) do
        local l = require("plugins.config.lsp." .. get_file_name(lsp))
        table.insert(server_names, l.name)
        table.insert(lsp_setups, l.setup)
      end

      require("neodev").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = server_names
      })

      for _, setup in ipairs(lsp_setups) do
        setup(on_attach, capabilities)
      end
    end
  }
}
