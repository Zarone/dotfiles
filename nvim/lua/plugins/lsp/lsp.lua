return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp'
  },
  config = function()
    local on_attach = function(_, _)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
      vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
    end

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Python
    vim.lsp.config('pylsp', {
      on_attach = on_attach,
      capabilities = capabilities
    })

    -- Lua
    vim.lsp.config('lua_ls', {
      on_attach = on_attach,
      capabilities = capabilities,
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
      capabilities = capabilities,
    })

    -- TypeScript
    vim.lsp.config('ts_ls', {
      on_attach = on_attach,
      filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
      capabilities = capabilities,
      cmd = { "typescript-language-server", "--stdio" }
    })

    -- CSS
    vim.lsp.config('cssls', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Tailwind
    vim.lsp.config('tailwindcss', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- GoLang
    vim.lsp.config('gopls', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Java
    vim.lsp.config('jdtls', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- C
    vim.lsp.config('clangd', {
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { "clangd", "--compile-commands-dir=build" },
    })

    -- ESLint
    vim.lsp.config('eslint', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Latex
    vim.lsp.config('texlab', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.config('ltex_plus', {
      capabilities = capabilities,

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
  end
}
