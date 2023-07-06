return {
  name = "eslint",
  setup = function (on_attach, capabilities)
    require("lspconfig").eslint.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}
