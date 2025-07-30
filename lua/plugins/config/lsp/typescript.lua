return {
  name = "ts_ls",
  setup = function(on_attach, capabilities)
    require("typescript-tools").setup {
      on_attach = function(client, buffer)
        on_attach(client, buffer)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Organise imports" })
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>li", "<cmd>TSToolsAddMissingImports<cr>", { desc = "Add imports" })
      end,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        tsserver_max_memory = "auto",
        tsserver_file_preferences = {
          quotePreference = "single",
          importModuleSpecifierPreference = "relative",
          importModuleSpecifierEnding = "minimal",
          includeInlayParameterNameHints = "all",
          includeCompletionsForModuleExports = true
        },
        tsserver_format_options = {
          insertSpaceAfterCommaDelimiter = true,
          insertSpaceAfterConstructor = true,
          insertSpaceAfterFunctionKeywordForAnonymousFunctions = false,
          insertSpaceAfterKeywordsInControlFlowStatements = true,
          insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
          insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
          insertSpaceAfterSemicolonInForStatements = true,
          insertSpaceAfterTypeAssertion = true,
          insertSpaceBeforeAndAfterBinaryOperators = true,
          insertSpaceBeforeFunctionParenthesis = false,
          insertSpaceBeforeTypeAnnotation = false,
          insertSpaceAfterConstructor = false,
          placeOpenBraceOnNewLineForControlBlocks = false,
          placeOpenBraceOnNewLineForFunctions = false,
          semicolons = 'insert',
          trimTrailingWhitespace = true,
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false
        }
      },
    }
  end
}
