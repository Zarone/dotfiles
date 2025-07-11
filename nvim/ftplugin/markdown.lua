-- define options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

vim.keymap.set('n', '<leader>ll', ':MarkdownPreview<CR>', opts)

-- Basic formatting settings
vim.g.markdown_recommended_style = 0

vim.opt_local.wrap = true

vim.opt_local.spell = true
