local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
end
return {
    {

	'rose-pine/neovim',
	tag="v3.0.2",
	config = function()
	    vim.cmd.colorscheme "rose-pine"
	    enable_transparency()
	end
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
	}
    }
}
