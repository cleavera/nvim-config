return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  opts = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    return {
      opts = {
        colors = {
          bright_bg = utils.get_highlight("Folded").bg,
          bright_fg = utils.get_highlight("Folded").fg,
          red = utils.get_highlight("DiagnosticError").fg,
          dark_red = utils.get_highlight("DiffDelete").bg,
          green = utils.get_highlight("String").fg,
          blue = utils.get_highlight("Function").fg,
          gray = utils.get_highlight("NonText").fg,
          orange = utils.get_highlight("Constant").fg,
          purple = utils.get_highlight("Statement").fg,
          cyan = utils.get_highlight("IncSearch").bg,
          diag_warn = utils.get_highlight("DiagnosticWarn").fg,
          diag_error = utils.get_highlight("DiagnosticError").fg,
          diag_hint = utils.get_highlight("DiagnosticHint").fg,
          diag_info = utils.get_highlight("DiagnosticInfo").fg,
          git_del = utils.get_highlight("diffRemoved").fg,
          git_add = utils.get_highlight("diffAdded").fg,
          git_change = utils.get_highlight("diffChanged").fg,
        }
      },
      statusline = {
        require("plugins.config.heirline.vimode-indicator"),
        require("plugins.config.heirline.space"),
        require("plugins.config.heirline.filename"),
        require("plugins.config.heirline.spacer"),
        require("plugins.config.heirline.lsp"),
        require("plugins.config.heirline.space"),
        require("plugins.config.heirline.git"),
        require("plugins.config.heirline.space"),
        require("plugins.config.heirline.file-progress"),
        require("plugins.config.heirline.space"),
      },
      tabline = {
        require("plugins.config.heirline.buffers"),
        require("plugins.config.heirline.spacer"),
        require("plugins.config.heirline.project-name"),
      },
    }
  end,
  config = function(_, opts)
    require("heirline").setup(opts)
  end
}
