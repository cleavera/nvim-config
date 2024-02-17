local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
  '.git',
}

local function organize_imports()
  local params = {
    command = 'pyright.organizeimports',
    arguments = { vim.uri_from_bufnr(0) },
  }
  vim.lsp.buf.execute_command(params)
end

local function set_python_path(path)
  local clients = vim.lsp.get_active_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = 'pyright',
  }
  for _, client in ipairs(clients) do
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
    client.notify('workspace/didChangeConfiguration', { settings = nil })
  end
end

return {
  name = "pyright",
  setup = function (on_attach, capabilities)
    require("lspconfig").pyright.setup({
      capabilities = capabilities,
      on_attach = function(client, buffer)
        on_attach(client, buffer)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>lo", "<cmd>OrganizeImports<cr>", { desc = "Organise imports" })
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>lR", "<cmd>lua require('FTerm').run({'python \"'..vim.fn.expand('%:p')..'\"'})<cr>", { desc = "Run this" })
      end,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'openFilesOnly',
          },
        },
      },
      commands = {
        OrganizeImports = {
          organize_imports,
          description = 'Organize Imports',
        },
        PyrightSetPythonPath = {
          set_python_path,
          description = 'Reconfigure pyright with the provided python path',
          nargs = 1,
          complete = 'file',
        },
      }
    })
  end
}
