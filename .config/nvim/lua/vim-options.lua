vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set cursorline")
vim.cmd("set ignorecase")
vim.cmd("set incsearch")

vim.opt.listchars:append({ space = '·' })
vim.opt.listchars:append({ tab = '» ' })
vim.opt.listchars:append({ precedes = '…' })
vim.opt.listchars:append({ extends = '…' })
vim.opt.listchars:append({ eol = '↵' })

vim.opt.list = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.g.mapleader = " "
