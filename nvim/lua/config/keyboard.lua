vim.g.mapleader = '\\'

-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-- ">" to expand panel
vim.keymap.set('n', '>', ':vertical res +5<CR>', opts)

-- "<" to shrink panel
vim.keymap.set('n', '<', ':vertical res -5<CR>', opts)

-- change buffers:
vim.keymap.set('n', 'H', ':bp<CR>', opts)
vim.keymap.set('n', 'L', ':bn<CR>', opts)

-- j/k will move virtual lines (lines that wrap)
vim.keymap.set('n', 'j', 'gj', opts)
vim.keymap.set('n', 'k', 'gk', opts)
vim.keymap.set('v', 'j', 'gj', opts)
vim.keymap.set('v', 'k', 'gk', opts)
