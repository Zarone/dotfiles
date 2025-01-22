local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim' if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, "packer")
if not status then
  return
end

return packer.startup(function(use)
  use('wbthomason/packer.nvim')

  -- Colorschemes (256 color)
  --use('morhetz/gruvbox')
  --use('sainnhe/sonokai')
  --use('yorickpeterse/nvim-grey')

  -- Colorschemes (True color)
  use ('folke/tokyonight.nvim')
  use('rose-pine/neovim')

  -- File exploreer
  use('preservim/nerdtree')

  -- Latex compiler
  use('lervag/vimtex')

  -- Markdown previewer
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  })

  -- Visual changes
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('ryanoasis/vim-devicons')

  -- Easily comment code
  use('preservim/nerdcommenter')

  -- LSP Settings
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig"
  }

  -- LSP Autocomplete
  use "hrsh7th/cmp-nvim-lsp"
  use 'hrsh7th/nvim-cmp'

  -- LSP autocomplete and snippets
  use "L3MON4D3/LuaSnip"
  use { 'saadparwaiz1/cmp_luasnip' }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Debugger
  use 'mfussenegger/nvim-dap'
  use {'jay-babu/mason-nvim-dap.nvim', requires={"mfussenegger/nvim-dap", "williamboman/mason.nvim"} }
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
  use 'mfussenegger/nvim-dap-python'
  use "julianolf/nvim-dap-lldb"
  use "theHamsta/nvim-dap-virtual-text"
  use 'nvim-telescope/telescope-dap.nvim'

  -- Adds TMUX compatability
  use 'christoomey/vim-tmux-navigator'

  if packer_bootstrap then
    require("packer").sync()
  end
end)
