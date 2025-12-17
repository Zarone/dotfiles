return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
	["<CR>"] = cmp.mapping.confirm { select = true },

	["<Tab>"] = cmp.mapping(function(fallback)
	  if cmp.visible() then
	    cmp.select_next_item()
	  else
	    fallback()
	  end
	end, { "i", "s" }),
	['<C-E>'] = cmp.config.disable,
	['<C-S-E>'] = cmp.mapping.abort(),
	["<S-Tab>"] = cmp.mapping(function(fallback)
	  local luasnip = require("luasnip")
	  if cmp.visible() then
	    cmp.select_prev_item()
	  else
	    fallback()
	  end
	end, { "i", "s" }),
      }),
      snippet = {
	expand = function(args)
	  require("luasnip").lsp_expand(args.body)
	end,
      },
      sources = cmp.config.sources(
	{
	  {name="nvim_lsp"},
	  {name="luasnip"}
	},
	{
	  {name="buffer"},
	}
      ),
    })
  end,
}
