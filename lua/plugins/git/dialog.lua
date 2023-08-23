local M = {}

local function get_screen_size()
  local columns = vim.api.nvim_get_option("columns")
  return {
    cols = columns,
    rows = vim.api.nvim_win_get_height(0)
  }
end

local function calculate_size(relative_size, total_padding)
  local screen_size = get_screen_size()
  local adjusted_size = {
    cols = screen_size.cols - total_padding.cols,
    rows = screen_size.rows - total_padding.rows
  }

  return {
    cols = math.floor(adjusted_size.cols * relative_size.cols),
    rows = math.floor(adjusted_size.rows * relative_size.rows)
  }
end

local function open_window(buf, size, offset)
  return vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    style = 'minimal',
    width = size.cols,
    height = 33,
    col = offset.cols,
    row = offset.rows,
    border = 'single'
  })
end

function M:is_open(win)
  local is_open = false

  for _, value in pairs(table) do
    if value == win then
      is_open = true
    end
  end

  return is_open
end

function M:open_fullscreen(buf)
  return open_window(buf, calculate_size({ cols = 1, rows = 1 }, { cols = 8, rows = 4 }), { cols = 4, rows = 2 })
end

function M:open_leftsplit(buf)
  return open_window(buf, calculate_size({ cols = 0.5, rows = 1 }, { cols = 10, rows = 0 }), { cols = 4, rows = 2 })
end

function M:open_rightsplit(buf)
  local size = calculate_size({ cols = 0.5, rows = 1 }, { cols = 10, rows = 0 })
  return open_window(buf, size, { rows = 2, cols = size.cols + 6})
end

return M
