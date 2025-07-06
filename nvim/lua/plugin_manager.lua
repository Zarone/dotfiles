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
  use 'nvim-lua/plenary.nvim'

  -- Colorschemes (256 color)
  --use('morhetz/gruvbox')
  --use('sainnhe/sonokai')
  --use('yorickpeterse/nvim-grey')

  -- Colorschemes (True color)
  use ('folke/tokyonight.nvim')
  use({'rose-pine/neovim', tag="v3.0.2"})

  -- File exploreer
  --use('preservim/nerdtree')
  use("stevearc/oil.nvim")
  use {
    'refractalize/oil-git-status.nvim',

    after = {
      "oil.nvim",
    },

    config = function()
      require('oil-git-status').setup({
        show_ignored = false
      })
    end
  }

  --Latex compiler
  use('lervag/vimtex')

  -- Markdown previewer
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown", "vimwiki" } end,
    ft = { "markdown", "vimwiki" },
  })

  -- Visual changes
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use 'echasnovski/mini.icons'
  use 'nvim-tree/nvim-web-devicons'

  -- Easily comment code
  use('preservim/nerdcommenter')

  -- LSP Settings
  use {
    "williamboman/mason.nvim",
    tag = "v1.11.0"
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    tag = "v1.32.0"
  }
  use {
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

  -- Git Integration
  use 'lewis6991/gitsigns.nvim'

  -- Wiki
  use 'vimwiki/vimwiki'

  if packer_bootstrap then
    require("packer").sync()
  end
end)
