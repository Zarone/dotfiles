-- define options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-- for some reason, if I don't do this it triggers on CMakeLists.txt
if not vim.fn.filereadable('CMakeLists.txt') then
  vim.keymap.set('n', '<leader>ll', ':MarkdownPreview<CR>', opts)
end

vim.g.markdown_recommended_style = 0

vim.opt_local.wrap = true

vim.opt.spell = true
