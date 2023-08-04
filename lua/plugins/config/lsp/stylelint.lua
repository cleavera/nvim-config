return {
  name = "stylelint_lsp",
  setup = function(on_attach, capabilities)
    local nvim_lsp = require('lspconfig')

    local filetypes = {
      css = { 'stylelint' },
      scss = { 'stylelint' },
      less = { 'stylelint' },
    }
    local linters = {
      stylelint = {
        sourceName = 'stylelint',
        command = 'npx',
        args = { 'stylelint', '--formatter', 'compact', '%filepath' },
        rootPatterns = { '.stylelintrc' },
        debounce = 100,
        formatPattern = {
          [[: line (\d+), col (\d+), (warning|error) - (.+?) \((.+)\)]],
          {
            line = 1,
            column = 2,
            security = 3,
            message = { 4, ' [', 5, ']' },
          },
        },
        securities = {
          warning = 'warning',
          error = 'error',
        },
      },
    }

    local formatters = {
      stylelint = {
        command = 'npx',
        args = { 'stylelint', '--fix', '--stdin', '--stdin-filename', '%filepath' },
      }
    }
    local formatFiletypes = {
      css = { 'stylelint' },
      scss = { 'stylelint' },
      less = { 'stylelint' },
    }

    nvim_lsp.diagnosticls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = vim.tbl_keys(filetypes),
      init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes,
      }
    }
  end
}
