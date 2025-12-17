return {
  "vimwiki/vimwiki",
  lazy = false, -- vimwiki should load early
  init = function()
    -- Vimwiki configuration (must be in init, not config)
    vim.g.vimwiki_list = {
      {
        path = "~/Dropbox/vimwiki",
        syntax = "markdown",
        ext = ".md",
        links_space_char = "_",
        auto_diary_index = 1,
        auto_generate_links = 1,
        auto_export = 0,
        auto_toc = 1,
        auto_tags = 1,
        auto_generate_tags = 1,
      },
    }

    -- Use markdown for .md files
    vim.g.vimwiki_global_ext = 1
    vim.g.vimwiki_ext2syntax = {
      [".md"] = "markdown",
      [".markdown"] = "markdown",
    }

    vim.g.vimwiki_markdown_link_ext = 1
    vim.g.vimwiki_markdown_syntax = 1
  end,

  config = function()
    -- Ensure vimwiki directory exists
    local vimwiki_path = vim.fn.expand("~/Dropbox/vimwiki")
    if vim.fn.isdirectory(vimwiki_path) == 0 then
      vim.fn.mkdir(vimwiki_path, "p")
    end

    -- Filetype-specific keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "vimwiki",
      callback = function()
        -- Follow links
        vim.keymap.set(
          "n",
          "gd",
          "<Plug>VimwikiFollowLink",
          { buffer = true, noremap = false, desc = "Vimwiki follow link" }
        )

        -- Follow link in new tab
        vim.keymap.set(
          "n",
          "<leader>gd",
          "<Plug>VimwikiFollowLinkInTab",
          { buffer = true, noremap = false, desc = "Vimwiki follow link in tab" }
        )

        -- Remove conflicting mapping (oil.nvim)
        pcall(vim.keymap.del, "n", "-", { buffer = true })
      end,
    })
  end,
}

