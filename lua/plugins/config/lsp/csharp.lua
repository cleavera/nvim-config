return {
  name = "omnisharp",
  setup = function (on_attach, capabilities)
    require("lspconfig").omnisharp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}
