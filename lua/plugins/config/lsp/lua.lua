return {
  name = "lua_ls",
  setup = function (on_attach, capabilities)
      require("lspconfig").lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace"
            },
            runtime = {
              version = "LuaJIT"
            },
            workspace = {
              checkThirdParty = false
            }
          }
        }
      })
  end
}
