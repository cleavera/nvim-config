local Handler = {}
local M = {
  _handlers = Handler,
  _store = {
    showing_tracked = true,
    showing_untracked = true,
    showing_commits = true
  }
}
local dialog = require('plugins.git.dialog')
local api = require('plugins.git.api')

function Handler:_get_change(window)
  local cursor = vim.api.nvim_win_get_cursor(window)
  local change = nil

  for _, handler in pairs(self.handlers.untracked) do
    if handler.line == cursor[1] then
      change = handler.change
    end
  end

  if change == nil then
    for _, handler in pairs(self.handlers.tracked) do
      if handler.line == cursor[1] then
        change = handler.change
      end
    end
  end

  return change
end

function Handler:_get_section(window)
  local cursor = vim.api.nvim_win_get_cursor(window)
  local section = nil

  for _, handler in pairs(self.handlers.sections) do
    if handler.line == cursor[1] then
      section = handler.name
    end
  end

  return section
end

function Handler:add()
  local change = self:_get_change(M.win)

  if change ~= nil then
    api.add(change.file)
    M:render(M.buf)
  end
end

function Handler:add_all()
  api.add_all()
  M:render(M.buf)
end

function Handler:unstage()
  local change = self:_get_change(M.win)

  if change ~= nil then
    api.reset(change.file)
    M:render(M.buf)
  end
end

function Handler:revert()
  local change = self:_get_change(M.win)

  if change ~= nil then
    api.revert(change.file)
    M:render(M.buf)
  end
end

function Handler:open()
  local change = self:_get_change(M.win)

  if change ~= nil then
    M:open_change(change)
  end
end

function Handler:quick_commit()
  api.quick_commit()
  M:render(M.buf)
end

function Handler:toggle_section()
  local section = self:_get_section(M.win)

  if section ~= nil then
    if section == 'tracked' then
      M._store.showing_tracked = not M._store.showing_tracked
    elseif section == 'untracked' then
      M._store.showing_untracked = not M._store.showing_untracked
    elseif section == 'commits' then
      M._store.showing_commits = not M._store.showing_commits
    end

    M:render(M.buf)

    return
  end
end

function Handler:diff()
  local change = self:_get_change(M.win)

  if change ~= nil then
    require('plugins.git.diff'):open(change)
  end
end

function Handler:close()
  M:close()
end

function M:open_change(change)
  self:close()
  vim.cmd.edit(change.file)
end

function M:close()
  if M.win ~= nil then
    vim.api.nvim_win_close(M.win, true)
  end
end

function M:get_buf()
  if self.buf == nil then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'GitDiff')
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

    self.buf = buf
  end

  return self.buf
end

function M:get_window()
  local buf = self:get_buf()
  if self.win == nil then
    self.win = dialog:open_fullscreen(buf)

    return self.win
  end

  if not dialog:is_open(self.win) then
    self.win = dialog:open_fullscreen(buf)
  end

  return self.win
end

function M:provider(change)
  if change.untracked then
    return "   " .. change.file
  end

  local stage_icon = "󰄱"

  if change.staged then
    if change.partial then
      stage_icon = "󰛲"
    else
      stage_icon = "󰱒"
    end
  end

  return " " .. stage_icon .. " " .. change.file .. " (" .. change.type .. ")"
end

function M:open()
  self:init()
  local b = self:get_buf()
  self:get_window()
  self:render(b)
end

local function exec_handler(...)
  local out = "<cmd>"
  local args = { ... }

  for i, cmd in ipairs(args) do
    if i ~= 1 then
      out = out .. " | execute('" .. cmd .. "')"
    else
      out = out .. "execute('" .. cmd .. "')"
    end
  end

  return out .. '<cr>'
end

function M:render(b)
  local write_buffer = {}

  local handlers = {
    untracked = {},
    tracked = {},
    sections = {}
  }

  self:_tracked_section(handlers, write_buffer)
  self:_untracked_section(handlers, write_buffer)
  self:_origin_section(handlers, write_buffer)

  vim.api.nvim_buf_set_option(b, 'modifiable', true)
  vim.api.nvim_buf_set_lines(b, 0, -1, false, write_buffer)
  vim.api.nvim_buf_set_option(b, 'modifiable', false)
  vim.api.nvim_buf_add_highlight(b, -1, "DiagnosticInfo", 0, 0, -1)

  self._handlers.handlers = handlers

  local handler_commands = {
    close = "lua require(\"plugins.git.summary\")._handlers:close()",
    add = "lua require(\"plugins.git.summary\")._handlers:add()",
    add_all = "lua require(\"plugins.git.summary\")._handlers:add_all()",
    unstage = "lua require(\"plugins.git.summary\")._handlers:unstage()",
    revert = "lua require(\"plugins.git.summary\")._handlers:revert()",
    open = "lua require(\"plugins.git.summary\")._handlers:open()",
    toggle_section = "lua require(\"plugins.git.summary\")._handlers:toggle_section()",
    diff = "lua require(\"plugins.git.summary\")._handlers:diff()",
    quick_commit = "lua require(\"plugins.git.summary\")._handlers:quick_commit()",
  }

  vim.api.nvim_buf_set_keymap(b, "n", "<Esc>", exec_handler(handler_commands.close), {})
  vim.api.nvim_buf_set_keymap(b, "n", "a", exec_handler(handler_commands.add), {})
  vim.api.nvim_buf_set_keymap(b, "n", "A", exec_handler(handler_commands.add_all), {})
  vim.api.nvim_buf_set_keymap(b, "n", "u", exec_handler(handler_commands.unstage), {})
  vim.api.nvim_buf_set_keymap(b, "n", "r", exec_handler(handler_commands.revert), {})
  vim.api.nvim_buf_set_keymap(b, "n", "o", exec_handler(handler_commands.open), {})
  vim.api.nvim_buf_set_keymap(b, "n", "<Enter>", exec_handler(handler_commands.toggle_section, handler_commands.diff), {})
  vim.api.nvim_buf_set_keymap(b, "n", "c", exec_handler(handler_commands.quick_commit), {})
end

function M:init()
  if self.initialised then
    return
  end

  self.initialised = true

  vim.api.nvim_create_autocmd('User', {
    pattern = {
      "GitGudDiffClose"
    },
    callback = function()
      if M.win then
        vim.schedule(function()
          vim.api.nvim_set_current_win(M.win)
        end)
      end
    end,
    once = false
  })
end

function M:_tracked_section(handlers, write_buffer)
  if M._store.showing_tracked then
    table.insert(write_buffer, " Tracked changes")
    table.insert(handlers.sections, { name = "tracked", line = #write_buffer })
    table.insert(write_buffer, "")

    local tracked_changes = require('plugins.git.api').tracked()
    for _, change in ipairs(tracked_changes) do
      table.insert(write_buffer, self:provider(change))
      table.insert(handlers.tracked, { change = change, line = #write_buffer })
    end
  else
    table.insert(write_buffer, " Tracked changes")
    table.insert(handlers.sections, { name = "tracked", line = #write_buffer })
  end

  table.insert(write_buffer, "")
end

function M:_untracked_section(handlers, write_buffer)
  local untracked_changes = api.untracked()

  if next(untracked_changes) == nil then
    return
  end

  if M._store.showing_untracked then
    table.insert(write_buffer, " Untracked changes")
    table.insert(handlers.sections, { name = "untracked", line = #write_buffer })
    table.insert(write_buffer, "")

    for _, change in ipairs(untracked_changes) do
      table.insert(write_buffer, self:provider(change))
      table.insert(handlers.untracked, { change = change, line = #write_buffer })
    end
  else
    table.insert(write_buffer, " Untracked changes")
    table.insert(handlers.sections, { name = "untracked", line = #write_buffer })
  end
  table.insert(write_buffer, "")
end

function M:_origin_section(handlers, write_buffer)
  local commits = api.get_unpushed_commits()

  if next(commits) == nil then
    return
  end

  if not M._store.showing_commits then
    table.insert(write_buffer,
      " " .. api.get_current_branch() .. " -> " .. api.get_remote_branch() .. " (" .. #commits .. " commits)")
    table.insert(handlers.sections, { name = "commits", line = #write_buffer })

    return
  end

  table.insert(write_buffer,
    " " .. api.get_current_branch() .. " -> " .. api.get_remote_branch() .. " (" .. #commits .. " commits)")
  table.insert(handlers.sections, { name = "commits", line = #write_buffer })
  table.insert(write_buffer, "")

  for _, commit in ipairs(commits) do
    table.insert(write_buffer, "   " .. commit.message)
  end
end

return M
