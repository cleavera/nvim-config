return {
  name = "yamlls",
  setup = function (on_attach, capabilities)
    require("lspconfig").yamlls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}
