local conditions = require("heirline.conditions")

return {
  condition = function()
    return vim.g.project and vim.g.project.is_git_project
  end,


  hl = { fg = "git_branch" },


  { -- git branch name
    provider = function(self)
      return " " .. vim.g.project.branch
    end,
    hl = { bold = true }
  },
  {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = "("
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ("+" .. count)
      end,
      hl = { fg = "git_add" },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ("-" .. count)
      end,
      hl = { fg = "git_del" },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ("~" .. count)
      end,
      hl = { fg = "git_change" },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = ")",
    },
  }
  -- You could handle delimiters, icons and counts similar to Diagnostics
}
