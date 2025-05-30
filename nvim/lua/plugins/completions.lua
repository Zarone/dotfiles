local cmp = require("cmp")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm { select = true },

    ["<Tab>"] = cmp.mapping(function(fallback)
      local luasnip = require("luasnip")
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      --elseif has_words_before() then
        --cmp.complete()
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
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
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

