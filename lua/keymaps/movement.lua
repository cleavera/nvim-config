local map = vim.api.nvim_set_keymap

-- Move up/down on VISUAL line instead of a ACTUAL line
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

vim.keymap.set("n", "*", "<cmd>let @/='\\<'.expand('<cword>').'\\>'<CR>", { silent = true })
