return {
  name = "omnisharp",
  setup = function (on_attach, capabilities)
    require("lspconfig").omnisharp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      vim.api.nvim_create_user_command("StartDocker", function()
        require('FTerm').run({'docker compose -f C:\\www\\mhr\\MHR.DotNet.LocalDevelopment\\docker-compose.yml -f C:\\www\\mhr\\MHR.DotNet.LocalDevelopment\\docker-compose.payroll.yml up'})
      end, {})
    })
  end
}
