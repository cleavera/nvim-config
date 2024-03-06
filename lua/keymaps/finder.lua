local which_key = require("which-key")
which_key.register({
  ["<leader>f"] = { name = "Finder" }
})

local telescope = require("telescope.builtin")
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')
local entry_display = require('telescope.pickers.entry_display') 

vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = "Search files" })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = "Find buffer" })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = "Search help" })
vim.keymap.set('n', '<leader>fc', telescope.commands, { desc = "Commmands" })
vim.keymap.set('n', '<leader>fC', telescope.colorscheme, { desc = "Color schemes" })

local function get_file_name(path)
  return vim.fn.fnamemodify(path, ":t")
end

local function find_files(opts)
  return telescope.find_files(themes.get_dropdown({
    layout_config = {
      width = function(_, max_columns, _)
        return math.min(max_columns, 120)
      end,

      height = function(_, _, max_lines)
        return math.min(max_lines, 20)
      end,
    }
  }))
end

local function modified_files(opts)
  local changes = require('plugins.git.api').status()

  return telescope.git_status(
    themes.get_dropdown({
      prompt_title = "Modified files",
      sorter = sorters.get_fzy_sorter({}),
      layout_config = {
        width = function(_, max_columns, _)
          return math.min(max_columns, 120)
        end,

        height = function(_, _, max_lines)
          return math.min(max_lines, 20)
        end,
      },
      finder = finders.new_table({
        results = changes,
        entry_maker = function(entry)
          local displayer = entry_display.create({
            separator = " ",
            items = {
              {},
              { remaining = true },
            },
          });

          return {
            value = entry.file,
            ordinal = entry.file,
            path = entry.file,
            display = function(entry)
              return displayer {
                { get_file_name(entry.value), "TelescopeResultsIdentifier" },
                { entry.value, "NonText" }
              }
            end
          }
        end
      }),
    })
  );
end

vim.keymap.set('n', '<leader>ff', find_files, { desc = "Find file" })
vim.keymap.set('n', '<leader>fm', modified_files, { desc = "Find modified file" })
vim.keymap.set('n', '<a-h>', '<cmd>noh<cr>', { desc = "Clear search" })
