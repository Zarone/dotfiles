vim.g.NERDTreeShowHidden = 1

vim.o.wildignore = vim.o.wildignore .. '*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*,'

vim.g.NERDTreeRespectWildIgnore = 1

vim.g.NERDTreeIgnore = { "\\.git$" }

-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

--- control b to open nerd tree
vim.keymap.set('n', '∫', ':NERDTreeToggle<CR>', opts)

