-- Vimwiki configuration
local M = {}

function M.setup()
  -- Set vimwiki to use markdown syntax
  vim.g.vimwiki_list = {
    {
      path = '~/vimwiki/',
      syntax = 'markdown',
      ext = '.md',
      links_space_char = '_',
      auto_diary_index = 1,
      auto_generate_links = 1,
      auto_export = 0,
      auto_toc = 1,
      auto_tags = 1,
      auto_generate_tags = 1,
    }
  }

  -- Set markdown as the default syntax
  vim.g.vimwiki_global_ext = 1
  vim.g.vimwiki_ext2syntax = {
    ['.md'] = 'markdown',
    ['.markdown'] = 'markdown',
  }

  -- Configure markdown syntax
  vim.g.vimwiki_markdown_link_ext = 1
  vim.g.vimwiki_markdown_syntax = 1

  -- Create vimwiki directory if it doesn't exist
  local vimwiki_path = vim.fn.expand('~/vimwiki')
  if vim.fn.isdirectory(vimwiki_path) == 0 then
    vim.fn.mkdir(vimwiki_path, 'p')
  end

  -- Set up keymaps for vimwiki
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'vimwiki',
    callback = function()
      -- gd to follow links (including PDF links)
      vim.keymap.set('n', 'gd', '<Plug>VimwikiFollowLink', {buffer = true, noremap = false})
      
      -- Leader + gd to open link in new tab
      vim.keymap.set('n', '<leader>gd', '<Plug>VimwikiFollowLinkInTab', {buffer = true, noremap = false})
      
      -- Disable vimwiki's - key for header removal to prevent conflict with oil.nvim
      vim.keymap.del('n', '-', {buffer = true})
    end
  })
end

-- Call setup function
M.setup()

return M 