local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

local function add_imports()
  local params = {
    command = "_typescript.addImports",
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
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>li", "<cmd>AddImports<cr>", { desc = "Add imports" })
      end,
      capabilities = capabilities,
      init_options = {
        preferences = {
          quotePreference = "single",
          importModuleSpecifierPreference = "relative",
          importModuleSpecifierEnding = "minimal"
        }
      },
      commands = {
        OrganizeImports = {
          organize_imports,
          description = "Organize Imports"
        },
        AddImports = {
          add_imports,
          description = "Add Imports"
        }
      },
      settings = {
        typescript = {
          format = {
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
            trimTrailingWhitespace = true
          },
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        },
        javascript = {
          format = {
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
            placeOpenBraceOnNewLineForControlBlocks = false,
            placeOpenBraceOnNewLineForFunctions = false,
            semicolons = 'insert',
            trimTrailingWhitespace = true
          },
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        }
      }
    })
  end
}
