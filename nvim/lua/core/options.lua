-- tab size
vim.opt.tabstop = 2

-- tab size on new line
vim.opt.shiftwidth = 2

-- use space when tab inserted
vim.opt.expandtab = true

-- print line numbers on side
vim.opt.number = true

-- I don't like relative line numbers
vim.opt.relativenumber = false

-- can delete any of these characters in insert mode
vim.opt.backspace = 'indent,eol,start'

-- briefly jump to matching bracket if insert one
vim.opt.showmatch = true

-- improves word wrap
vim.opt.formatoptions = 'l'
vim.opt.lbr = true

-- highlight current line
vim.opt.cursorline = true

-- warning before close unsaved file
vim.opt.confirm = true

-- let vim set title of window
vim.opt.title = true

-- turns off sounds
vim.opt.belloff = 'all'
