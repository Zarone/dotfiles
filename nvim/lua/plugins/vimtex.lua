vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_view_method = 'general'
vim.g.tex_conceal='abdmg'
vim.g.vimtex_complete_bib_simple=1
vim.api.nvim_win_set_option(0, 'conceallevel', 2)
vim.g.vimtex_view_general_viewer = 'zathura'

vim.g.timtex_compiler_latexmk = {
     options = {
         '-lualatex',
         '-pdf',
         '-shell-escape',
         '-verbose',
         '-file-line-error',
         '-synctex=1',
         '-interaction=nonstopmode',
     }
}

vim.g.vimtex_syntax_conceal = {
  accents = 1,
  ligatures = 1,
  cites = 1,
  fancy = 1,
  spacing = 1,
  greek = 1,
  math_bounds = 1,
  math_delimiters = 1,
  math_fracs = 1,
  math_super_sub = 1,
  math_symbols = 1,
  sections = 1,
  styles = 1,
}

vim.g.vimtex_compiler_tectonic = {
 build_dir = '~/Downloads',
 options = {
       '-lualatex',
       'tectonics',
       '--keep-logs',
       '--synctex'
     },
}

vim.g.vimtex_compiler_latexmk_engines = {
   _ = '-lualatex',
}

