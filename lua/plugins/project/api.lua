local M = {}

function M:list_recent()
  local project_file = vim.fn.stdpath('cache') .. '/.projects'

  if vim.fn.filereadable(project_file) == 0 then
    return {}
  end

  return vim.fn.readfile(project_file)
end

function M:add_recent(project)
  local projects = self:list_recent()
  local count = 0

  for i,old_project in ipairs(projects) do
    count = i

    if old_project == project then
      table.remove(projects, i)

      break
    end
  end

  if count > 9 then
    table.remove(projects)
  end

  table.insert(projects, 1, project)

  local project_file = vim.fn.stdpath('cache') .. '/.projects'
  vim.fn.writefile(projects, project_file, "b")
end

function M:open(project)
  vim.fn.chdir(project)
end

function M:config()
  self:open(vim.fn.stdpath("config"))
end

function M:list(projects_root)
  local out = vim.split(vim.api.nvim_exec2('!gitlist ' .. projects_root, { output = true }).output, '\n')
  local items = {}

  for i, line in ipairs(out) do
    if i > 2 and line ~= "" then
      table.insert(items, line)
    end
  end

  return items
end

return M
