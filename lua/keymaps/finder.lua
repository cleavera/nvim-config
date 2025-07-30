local which_key = require("which-key")
which_key.add({
  { "<leader>f", group = "Finder" },
  { "<leader>lg", group = "Goto" }
})

local telescope = require("telescope.builtin")
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')
local entry_display = require('telescope.pickers.entry_display') 

local theme = themes.get_dropdown({
  layout_strategy = "vertical",
  path_display = "shorten",
  layout_config = {
    prompt_position = "top",
    width = function(_, max_columns, _)
      return math.min(max_columns, 120)
    end,
    height = function(_, _, max_lines)
      return max_lines - 1
    end,
  }
})

vim.keymap.set('n', '<leader>fg', function() return require('telescope').extensions.live_grep_args.live_grep_args(theme) end, { desc = "Search files" })
vim.keymap.set('n', '<leader>ft', function() return telescope.grep_string(theme) end, { desc = "Search for this" })
vim.keymap.set('n', '<leader>ff', function() return telescope.find_files(theme) end, { desc = "Find file" })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = "Find buffer" })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = "Search help" })
vim.keymap.set('n', '<leader>fc', telescope.commands, { desc = "Commmands" })
vim.keymap.set('n', '<leader>fC', telescope.colorscheme, { desc = "Color schemes" })
vim.keymap.set("n", "<leader>lgd", telescope.lsp_definitions, { desc = "Goto definition" })
vim.keymap.set("n", "<leader>lgr", telescope.lsp_references, { desc = "Goto references" })
vim.keymap.set("n", "<leader>lgi", telescope.lsp_implementations, { desc = "Goto implementation" })
vim.keymap.set("n", "<leader>lgD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
vim.keymap.set("n", "<leader>lgt", telescope.lsp_type_definitions, { desc = "Goto type definition" })

local function get_file_name(path)
  return vim.fn.fnamemodify(path, ":t")
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

vim.keymap.set('n', '<leader>fm', modified_files, { desc = "Find modified file" })
vim.keymap.set('n', '<a-h>', '<cmd>noh<cr>', { desc = "Clear search" })
