-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-- I used to use this keybinding,
-- but I want to get used to a default
-- keybinding so that I can work without 
-- my settings
---- "kj" to go into normal mode
--vim.keymap.set('i', 'kj', '<ESC>', opts)

-- ">" to expand panel
vim.keymap.set('n', '>', ':vertical res +5<CR>', opts)

-- "<" to shrink panel
vim.keymap.set('n', '<', ':vertical res -5<CR>', opts)

-- j/k will move virtual lines (lines that wrap)
vim.keymap.set('n', 'j', 'gj', opts)
vim.keymap.set('n', 'k', 'gk', opts)
vim.keymap.set('v', 'j', 'gj', opts)
vim.keymap.set('v', 'k', 'gk', opts)

-- change buffers:
vim.keymap.set('n', 'H', ':bp<CR>', opts)
vim.keymap.set('n', 'L', ':bn<CR>', opts)

-- close buffer without closing window
vim.keymap.set('n', '<leader>q', ':bp<CR>:bdelete #<CR>', opts)
