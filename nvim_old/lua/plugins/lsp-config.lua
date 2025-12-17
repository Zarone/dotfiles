require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" }
})

local on_attach = function(_, _)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
end


-- setup C header files with cmake
local function setup_clangd()
  local project_root = vim.fn.getcwd()

  if vim.fn.filereadable(project_root .. "/CMakeLists.txt") == 0 then
    print("No CMake file found")
    return
  end

  if vim.fn.filereadable(project_root .. "/build/compile_commands.json") == 0 then
    print("Run \"cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -S . -B build\" and reload")
  end
end

local on_attach_setup_clang = function(_, _)
  on_attach()
  setup_clangd()
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
  capabilities = capabilities
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
  capabilities = capabilities
})

-- Tailwind
vim.lsp.config('tailwindcss', {
  on_attach = on_attach,
  capabilities = capabilities
})

-- GoLang
vim.lsp.config('gopls', {
  on_attach = on_attach,
  capabilities = capabilities
})

-- Java
vim.lsp.config('jdtls', {
  on_attach = on_attach,
  capabilities = capabilities
})

-- C
vim.lsp.config('clangd', {
  on_attach = on_attach_setup_clang,
  capabilities = capabilities,
  cmd = { "clangd", "--compile-commands-dir=build" },
})

-- ESLint
vim.lsp.config('eslint', {
  on_attach = on_attach,
  capabilities = capabilities
})

-- Latex
vim.lsp.config('texlab', {
  on_attach = on_attach,
  capabilities = capabilities
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

-- Format Code
vim.cmd('command! Format lua vim.lsp.buf.format()')

-- Diagnostic settings
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = false,
}
