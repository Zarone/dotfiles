-- define options
local opts = {
    noremap = true,      -- non-recursive
    silent = false,       -- do not show message
}

vim.keymap.set('n', '<leader>ll', ':!cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S . -B build<CR>', opts)
