local map = vim.api.nvim_set_keymap

-- Move up/down on VISUAL line instead of a ACTUAL line
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

vim.keymap.set("n", "*", "<cmd>let @/='\\<'.expand('<cword>').'\\>'<CR>", { silent = true })

vim.keymap.set("v", "J", ":<cmd>m '>+1<CR>gv=gv<CR>")
vim.keymap.set("v", "K", ":<cmd>m '<-2<CR>gv=gv<CR>")
