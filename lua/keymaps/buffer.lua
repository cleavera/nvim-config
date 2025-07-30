local which_key = require("which-key")
which_key.add({
  {"<leader>b", group = "Buffer" }
})

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local dropdown = require('telescope.themes').get_dropdown({})
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local entry_display = require('telescope.pickers.entry_display')

local function get_bufs()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_get_option(bufnr, "buflisted") and vim.api.nvim_buf_is_valid(bufnr)
  end, vim.api.nvim_list_bufs())
end

local function get_file_name(path)
  return vim.fn.fnamemodify(path, ":t")
end

local function open_picker(source)
  local opts = {
    prompt_title = "Buffers",
    sorter = sorters.get_fzy_sorter({}),
    layout_config = {
      width = function(_, max_columns, _)
        return math.min(max_columns, 120)
      end,

      height = function(_, _, max_lines)
        return math.min(max_lines, 15)
      end,
    },
    finder = finders.new_table({
      results = source,
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = " ",
          items = {
            {},
            { remaining = true },
          },
        });

        return {
          value = entry,
          ordinal = entry,
          display = function(entry)
            return displayer {
              { get_file_name(entry.value), "TelescopeResultsIdentifier" },
              { entry.value, "NonText" }
            }
          end
        }
      end
    }),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()

        vim.cmd('e ' .. selection.value)
      end)

      map({ "n", "i" }, "<C-c>", function()
        local selection = action_state.get_selected_entry()

        selection.valid = false
        vim.api.nvim_buf_delete(vim.fn.bufnr(selection.value), {})
      end)

      return true
    end
  }

  local projects = pickers.new(opts, dropdown)

  projects:find()
end

local function all_buffers_picker()
  local bufs = get_bufs()

  local namedBuffers = {}
  for k, v in pairs(bufs) do
    namedBuffers[k] = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(v), ":.")
  end

  open_picker(namedBuffers)
end

vim.keymap.set('n', '<leader>bc', function()
  vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), {})
end, { desc = "Close" })

vim.keymap.set('n', '<leader>bC', function()
  vim.cmd('bufdo bwipeout')
end, { desc = "Close all" })

vim.keymap.set('n', '<leader>bs', function()
  vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(false, true))
end, { desc = "Scratch buffer" })

vim.keymap.set('n', '<leader>bj', function()
  local bufs = get_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local next_buf = nil

  for i, buf in ipairs(bufs) do
    if buf == current_buf then
      next_buf = bufs[i + 1]
    end
  end

  if next_buf ~= nil then
    vim.api.nvim_set_current_buf(next_buf)
  end
end, { desc = "Next" })

vim.keymap.set('n', '<leader>bk', function()
  local bufs = get_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local next_buf = nil

  for i, buf in ipairs(bufs) do
    if buf == current_buf then
      next_buf = bufs[i - 1]
    end
  end

  if next_buf ~= nil then
    vim.api.nvim_set_current_buf(next_buf)
  end
end, { desc = "Previous" })

vim.keymap.set('n', '<leader>bs', function()
  vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(false, true))
end, { desc = "Scratch" })

vim.keymap.set('n', '<leader>br', '<cmd>e<cr>', { desc = "Reload" })
vim.keymap.set('n', '<leader>bb', '<cmd>b #<cr>', { desc = "Last" })

vim.keymap.set('n', '<leader>bl', function()
  all_buffers_picker()
end, { desc = "List buffers" })

vim.keymap.set('n', '<C-s>', '<cmd>wa<cr>')
vim.keymap.set('i', '<C-s>', '<cmd>wa<cr>')
vim.keymap.set('v', '<C-s>', '<cmd>wa<cr>')

vim.keymap.set('n', '<leader>br', '<cmd>e %<cr>', { desc = "Reload file" })
vim.keymap.set('n', '<leader>bf', '<cmd>only<cr>', { desc = "Focus" })
