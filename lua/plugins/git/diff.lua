local M = {}
local dialog = require('plugins.git.dialog')
local api = require('plugins.git.api')

function M:open(change)
  local b1 = vim.api.nvim_create_buf(false, true)
  self.win_current = dialog:open_rightsplit(b1)

  if (change.type == api.Type.ADD or change.type == api.Type.CHANGE or change.type == api.Type.UNTRACKED) then
    vim.cmd.edit(change.file)
  end

  vim.cmd.diffthis()
  vim.api.nvim_win_set_option(self.win_current, 'foldenable', false)

  local b2 = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(b2, 'filetype', vim.api.nvim_buf_get_option(b1, 'filetype'))
  self.win_prev = dialog:open_leftsplit(b2)

  if (change.type == api.Type.CHANGE or change.type == api.Type.DELETE) then
    vim.api.nvim_buf_set_lines(b2, 0, -1, false, require("plugins.git.api").unmodifiedFileContents(change.file))
  end

  vim.api.nvim_buf_set_option(b2, 'modifiable', false)
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
      vim.api.nvim_del_augroup_by_id(event_group)
      vim.api.nvim_win_close(self.win_current, true)
      vim.api.nvim_win_close(self.win_prev, true)
      self.win_current = -1
      self.win_prev = -1
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
        if (self.win_current ~= -1) then
          vim.api.nvim_set_current_win(self.win_current)
        end
      end)
    end,
    group = event_group
  })
end

return M
