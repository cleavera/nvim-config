return {
  condition = function(self)
    return vim.g.project
  end,

  provider = function(self)
    return vim.g.project.name 
  end,

  hl = { fg = "project" },
}
