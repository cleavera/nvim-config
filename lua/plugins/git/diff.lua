local Handler = {}
local M = {
  _handlers = Handler
}
local dialog = require('plugins.git.dialog')
local api = require('plugins.git.api')

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

function Handler:next_diff()
  if M.current_change == nil then
    return
  end

  local next_change = api.get_next_change(M.current_change)

  if next_change == nil then
    return
  end

  M:open(next_change)
end

function Handler:prev_diff()
  if M.current_change == nil then
    return
  end

  local next_change = api.get_prev_change(M.current_change)

  if next_change == nil then
    return
  end

  M:open(next_change)
end

function Handler:close()
  M:close()
end

function Handler:open_change()
  if (M.current_change == nil) then
    return
  end

  local change = M.current_change

  M:close()
  require('plugins.git.summary'):open_change(change)
end

function M:close()
  local b = self:get_current_buffer()
  if self.win_current == nil or b == nil then return end

  if b ~= nil then
    if vim.fn.getbufinfo(b)[1].changed ~= 0 then
      local save_changes = vim.fn.confirm("Save changes?", "&Yes\n&No\n&Cancel")

      if save_changes == 3 then return end

      if save_changes == 1 then
        vim.api.nvim_command('write')
      end
    end
  end

  vim.api.nvim_win_close(self.win_current, true)
end

function M:get_prev_buffer()
  if self.win_prev == nil then
    return
  end

  return vim.fn.winbufnr(self.win_prev)
end

function M:get_current_buffer()
  if self.win_current == nil then
    return
  end

  return vim.fn.winbufnr(self.win_current)
end

function M:open_diff_windows()
  if self.win_current ~= nil then
    self:close()
  end

  local b1 = vim.api.nvim_create_buf(false, true)
  self.win_current = dialog:open_rightsplit(b1)
  vim.cmd.diffthis()
  vim.api.nvim_win_set_option(self.win_current, 'foldenable', false)

  local b2 = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(b2, 'filetype', vim.api.nvim_buf_get_option(b1, 'filetype'))
  self.win_prev = dialog:open_leftsplit(b2)

  vim.cmd.diffthis()
  vim.api.nvim_win_set_option(self.win_prev, 'foldenable', false)

  vim.api.nvim_set_current_win(self.win_current)

  local event_group = vim.api.nvim_create_augroup('diffgroup', { clear = true })

  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = {
      tostring(self.win_current),
      tostring(self.win_prev)
    },
    callback = function()
      local buf = M:get_current_buffer()

      vim.api.nvim_del_augroup_by_id(event_group)
      vim.api.nvim_win_close(self.win_current, true)
      vim.api.nvim_win_close(self.win_prev, true)

      if buf ~= nil then
        vim.api.nvim_buf_delete(buf, { force = true })
      end

      self.win_current = nil
      self.win_prev = nil
      self.current_change = nil
      vim.api.nvim_exec_autocmds('User', { pattern = 'GitGudDiffClose' })
    end,
    once = true,
    group = event_group
  })

  vim.api.nvim_create_autocmd('WinLeave', {
    pattern = {
      "*"
    },
    callback = function()
      vim.schedule(function()
        if (self.win_current ~= nil) then
          vim.api.nvim_set_current_win(self.win_current)
        end
      end)
    end,
    group = event_group
  })
end

function M:open(change)
  self:open_diff_windows()

  self.current_change = change
  local b2 = self:get_prev_buffer()

  local handler_commands = {
    close = "lua require(\"plugins.git.diff\")._handlers:close()",
    next_diff = "lua require(\"plugins.git.diff\")._handlers:next_diff()",
    prev_diff = "lua require(\"plugins.git.diff\")._handlers:prev_diff()",
    open_change = "lua require(\"plugins.git.diff\")._handlers:open_change()",
  }

  if (change.type == api.Type.ADD or change.type == api.Type.CHANGE or change.type == api.Type.UNTRACKED) then
    vim.cmd.edit(change.file)
  end

  local b1 = self:get_current_buffer()

  if b1 == nil or b2 == nil then
    return
  end

  vim.api.nvim_buf_set_option(b2, 'modifiable', true)

  if (change.type == api.Type.CHANGE or change.type == api.Type.DELETE) then
    vim.api.nvim_buf_set_lines(b2, 0, -1, false, require("plugins.git.api").unmodifiedFileContents(change.file))
  end

  vim.api.nvim_buf_set_option(b2, 'modifiable', false)
  vim.api.nvim_buf_set_keymap(b1, "n", "<Esc>", exec_handler(handler_commands.close), {})
  vim.api.nvim_buf_set_keymap(b1, "n", "<C-j>", exec_handler(handler_commands.next_diff), {})
  vim.api.nvim_buf_set_keymap(b1, "n", "<C-k>", exec_handler(handler_commands.prev_diff), {})
  vim.api.nvim_buf_set_keymap(b1, "n", "<C-o>", exec_handler(handler_commands.open_change), {})
end

return M
