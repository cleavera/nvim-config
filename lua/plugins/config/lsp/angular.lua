return {
  name = "angularls",
  setup = function (on_attach, capabilities)
    require("lspconfig").angularls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}
