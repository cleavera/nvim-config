local o = vim.opt
local g = vim.g

g.mapleader = " "

o.undofile = true -- Persistent undo's across all sessions
o.backup = false -- Don't write backups. (For better performance and, unneeded non-sense
o.writebackup = false -- Don't write backups.
o.shiftwidth = 2 -- Insert two shifts per indent.
o.autoindent = true -- Copy indent from the current line when starting a new line
o.breakindent = true -- Indent wrapped lines too.
o.copyindent = true -- Copy the structure of the existing lines' indents.
o.expandtab = true -- Convert tabs to spaces.
o.smartindent = true -- Non-strict cindent.
o.number = true -- Enable line numbers
o.laststatus = 3 -- Single status bar
o.showtabline = 0
o.nu = true
o.relativenumber = true
o.tabstop = 2
o.softtabstop = 2
o.undofile = true
o.hlsearch = true
o.incsearch = true
o.scrolloff = 8
o.updatetime = 250
o.timeoutlen = 300
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.cursorline = true
