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
require("lspconfig").pylsp.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- Lua
require("lspconfig").lua_ls.setup{
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
}

-- Rust
require("lspconfig").rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- TypeScript
require("lspconfig")["ts_ls"].setup {
  on_attach = on_attach,
  filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}

-- CSS
require("lspconfig").cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- Tailwind
require("lspconfig").tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- GoLang
require("lspconfig").gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- Java
require("lspconfig").jdtls.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- C
require("lspconfig").clangd.setup{
  on_attach = on_attach_setup_clang,
  capabilities = capabilities,
  cmd = { "clangd", "--compile-commands-dir=build" },
}

-- ESLint
require("lspconfig").eslint.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- Latex
require("lspconfig").texlab.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- Format Code
vim.cmd('command! Format lua vim.lsp.buf.format()')

-- Diagnostic settings
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = false,
}
