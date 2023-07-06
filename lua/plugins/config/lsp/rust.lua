return {
  name = "rust_analyzer",
  setup = function (on_attach, capabilities)
    require("lspconfig").rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}
