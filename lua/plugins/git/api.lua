local M = {}

M.Type = { ADD = "A", CHANGE = "M", DELETE = "D", UNKNOWN = " ", UNTRACKED = "?" }

M.status = function()
  local scripts = vim.api.nvim_exec2("!git status --porcelain", { output = true })
  local lines = vim.split(scripts.output, '\n')
  local items = {}

  for i, line in ipairs(lines) do
    if i > 2 then
      local staged = string.sub(line, 1, 1)
      local unstaged = string.sub(line, 2, 2)
      local file = string.sub(line, 4)

      if file ~= nil and file ~= '' then
        local item = {}

        if staged ~= M.Type.UNKNOWN and staged ~= M.Type.UNTRACKED then
          item.file = file
          item.staged = true
          item.untracked = false
          item.type = staged
        end

        if unstaged ~= M.Type.UNKNOWN and unstaged ~= M.Type.UNTRACKED then
          if item.staged then
            item.partial = true
          else
            item.file = file
            item.staged = false
            item.untracked = false
            item.type = unstaged
          end
        end

        if staged == M.Type.UNTRACKED or unstaged == M.Type.UNTRACKED then
          item.file = file
          item.staged = false
          item.untracked = true
          item.type = M.Type.UNTRACKED
        end

        if item ~= nil then
          table.insert(items, item)
        end
      end
    end
  end

  return items
end

M.untracked = function()
  local changes = M.status()
  local untracked = {}

  for _, change in ipairs(changes) do
    if change.untracked == true then
      table.insert(untracked, change)
    end
  end

  return untracked
end

M.tracked = function()
  local changes = M.status()
  local tracked = {}

  for _, change in ipairs(changes) do
    if change.untracked == false then
      table.insert(tracked, change)
    end
  end

  return tracked
end

M.unmodifiedFileContents = function(file)
  local scripts = vim.api.nvim_exec2("!git show HEAD:" .. file, { output = true })
  local lines = vim.split(string.gsub(scripts.output, "\r\n", "\n"), "\n")
  table.remove(lines, 1)
  table.remove(lines, 1)

  return lines
end

M.add = function(file)
  vim.api.nvim_exec2("!git add " .. file, { output = true })
end

M.add_all = function()
  vim.api.nvim_exec2("!git add -A", { output = true })
end

M.reset = function(file)
  vim.api.nvim_exec2("!git reset HEAD " .. file, { output = true })
end

M.revert = function(file)
  vim.api.nvim_exec2("!git checkout -- " .. file, { output = true })
end

M.revert_all = function()
  vim.api.nvim_exec2("!git checkout HEAD", { output = true })
end

M.quick_commit = function()
  local message = vim.fn.input('Commit message: ')

  if message == "" then
    return
  end

  vim.api.nvim_exec2("!git commit -m \"" .. message .. "\"", { output = true })
end

return M;
