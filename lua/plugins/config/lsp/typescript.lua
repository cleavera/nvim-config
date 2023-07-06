local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

return {
  name = "tsserver",
  setup = function(on_attach, capabilities)
    require("lspconfig").tsserver.setup({
      on_attach = function(_, buffer)
        on_attach(_, buffer)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>lo", "<cmd>OrganizeImports<cr>", { desc = "Organise imports" })
      end,
      capabilities = capabilities,
      commands = {
        OrganizeImports = {
          organize_imports,
          description = "Organize Imports"
        }
      }
    })
  end
}
