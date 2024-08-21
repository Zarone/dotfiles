require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", 'javascript', 'typescript', 'c' },
  sync_install = false,
  auto_install = true,

  highlight = {
    disable = { "latex" },
    enable = true,
    additional_vim_regex_highlighting = false,
    indent = { enable = true }
  },

  indent = { enable = true }
}
