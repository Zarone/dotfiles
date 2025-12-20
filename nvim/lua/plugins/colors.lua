local function enable_transparency()
  vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
end
return {
  {
    'rose-pine/neovim',
    tag="v3.0.2",
    config = function()
      require('rose-pine').setup({
	disable_background = true,
	styles = {
	  italic = false,
	},
      })
      vim.cmd.colorscheme "rose-pine"
      enable_transparency()
    end,
  },
  --{
    --"folke/tokyonight.nvim",
    --config = function()
    --vim.cmd.colorscheme "tokyonight"
    --enable_transparency()
    --end
  --},
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      theme = 'tokyonight'
    },
    config = function()
      require('lualine').setup({
	options = {
	  icons_enabled = true,
	  theme = 'auto',
	  component_separators = { left = '', right = ''},
	  section_separators = { left = '', right = ''},
	  disabled_filetypes = {
	    statusline = {},
	    winbar = {},
	  },
	  ignore_focus = {},
	  always_divide_middle = true,
	  always_show_tabline = true,
	  globalstatus = false,
	  refresh = {
	    statusline = 1000,
	    tabline = 1000,
	    winbar = 1000,
	    refresh_time = 16, -- ~60fps
	    events = {
	      'WinEnter',
	      'BufEnter',
	      'BufWritePost',
	      'SessionLoadPost',
	      'FileChangedShellPost',
	      'VimResized',
	      'Filetype',
	      'CursorMoved',
	      'CursorMovedI',
	      'ModeChanged',
	    },
	  }
	},
	sections = {
	  lualine_a = {'mode'},
	  lualine_b = {'branch', 'diff', 'diagnostics'},
	  lualine_c = {{'filename', path = 1}},
	  lualine_x = {'encoding', 'fileformat', 'filetype'},
	  lualine_y = {'progress'},
	  lualine_z = {'location'}
	},
	inactive_sections = {
	  lualine_a = {},
	  lualine_b = {},
	  lualine_c = {'filename'},
	  lualine_x = {'location'},
	  lualine_y = {},
	  lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
      })
    end
  },
  {
    'xiyaowong/transparent.nvim',
    lazy = false,
    config = function()
      vim.g.transparent_enabled = true
      require('transparent').setup({
	-- table: default groups
	groups = {
	  'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
	  'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
	  'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
	  'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
	  'EndOfBuffer',
	},
	-- table: additional groups that should be cleared
	extra_groups = {},
	-- table: groups you don't want to clear
	exclude_groups = {},
	-- function: code to be executed after highlight groups are cleared
	-- Also the user event "TransparentClear" will be triggered
	on_clear = function() end,
      })
    end
  }
}
