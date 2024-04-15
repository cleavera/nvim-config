local map = vim.api.nvim_set_keymap

-- Move up/down on VISUAL line instead of a ACTUAL line
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

vim.keymap.set("n", "<c-j>", "<cmd>cnext<cr>", { silent = true })
vim.keymap.set("n", "<c-k>", "<cmd>cprev<cr>", { silent = true })

vim.keymap.set("n", "*", "<cmd>let @/='\\<'.expand('<cword>').'\\>'<CR>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
