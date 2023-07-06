return {
  name = "azure_pipelines_ls",
  setup = function (on_attach, capabilities)
    require("lspconfig").azure_pipelines_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}
