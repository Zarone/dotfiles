local on_attach = function(_, _)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
end

-- Python
vim.lsp.config('pylsp', {
  on_attach = on_attach,
})

-- Lua
vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Rust
vim.lsp.config('rust_analyzer', {
  on_attach = on_attach,
})

-- TypeScript
vim.lsp.config('ts_ls', {
  on_attach = on_attach,
  filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
})

-- CSS
vim.lsp.config('cssls', {
  on_attach = on_attach,
})

-- Tailwind
vim.lsp.config('tailwindcss', {
  on_attach = on_attach,
})

-- GoLang
vim.lsp.config('gopls', {
  on_attach = on_attach,
})

-- Java
vim.lsp.config('jdtls', {
  on_attach = on_attach,
})

-- C
vim.lsp.config('clangd', {
  on_attach = on_attach,
  cmd = { "clangd", "--compile-commands-dir=build" },
})

-- ESLint
vim.lsp.config('eslint', {
  on_attach = on_attach,
})

-- Latex
vim.lsp.config('texlab', {
  on_attach = on_attach,
})

vim.lsp.config('ltex_plus', {
  filetypes = { "tex", "latex", "bib", "markdown" },

  settings = {
    ltex = {
      enabled = {"tex", "latex", "bib", "markdown"},
      language = "en-US",
      additionalRules = {
        enablePickyRules = true,
      },
      latex = {
        -- Let LTeX understand LaTeX commands
        commandExtensions = "all",
      },
    },
  },
})

vim.lsp.enable({'pylsp', 'lua_ls', 'rust_analyzer', 'ts_ls', 'cssls', 'tailwindcss', 'gopls', 'jdtls', 'clangd', 'eslint', 'texlab', 'ltex_plus'})
