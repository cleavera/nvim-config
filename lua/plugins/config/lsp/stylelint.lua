return {
  name = "stylelint_lsp",
  setup = function (on_attach, capabilities)
    require("lspconfig").stylelint_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}
