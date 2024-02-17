local function setup_colors()
    local utils = require("heirline.utils")

    return {
          default_bg = utils.get_highlight("statusline").bg,
          default_fg = utils.get_highlight("statusline").fg,
          git_del = utils.get_highlight("diffRemoved").fg,
          git_add = utils.get_highlight("diffAdded").fg,
          git_change = utils.get_highlight("diffChanged").fg,
          git_branch = utils.get_highlight("Constant").fg,
          lsp = utils.get_highlight("String").fg,
          project = utils.get_highlight("Function").fg,
          normal_mode_bg = utils.get_highlight("String").fg,
          normal_mode_fg = utils.get_highlight("NonText").fg,
          insert_mode_bg = utils.get_highlight("Error").fg,
          insert_mode_fg = utils.get_highlight("NonText").fg,
          visual_mode_bg = utils.get_highlight("Label").fg,
          visual_mode_fg = utils.get_highlight("NonText").fg,
          replace_mode_bg = utils.get_highlight("DiffDelete").bg,
          replace_mode_fg = utils.get_highlight("StatusLine").fg,
          change_mode_bg = utils.get_highlight("Macro").fg,
          change_mode_fg = utils.get_highlight("NonText").fg,
          readonly = utils.get_highlight("Constant").fg,
          filename = utils.get_highlight("IncSearch").bg,
          directory = utils.get_highlight("Directory").fg,
          modified = utils.get_highlight("String").fg,
    }
end

return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  opts = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    return {
      opts = {
        colors = setup_colors(),
      },
      statusline = {
        hl = { fg = "default_fg", bg = "default_bg" },
        require("plugins.config.heirline.vimode-indicator"),
        require("plugins.config.heirline.space"),
        require("plugins.config.heirline.filename"),
        require("plugins.config.heirline.spacer"),
        require("plugins.config.heirline.lsp"),
        require("plugins.config.heirline.space"),
        require("plugins.config.heirline.project-name"),
        require("plugins.config.heirline.space"),
        require("plugins.config.heirline.git"),
        require("plugins.config.heirline.space"),
        require("plugins.config.heirline.file-progress"),
        require("plugins.config.heirline.space"),
      },
    }
  end,
  config = function(_, opts)
    require("heirline").setup(opts)
    vim.api.nvim_create_augroup("Heirline", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local utils = require("heirline.utils")
        utils.on_colorscheme(setup_colors)
      end,
      group = "Heirline",
    })
  end
}
