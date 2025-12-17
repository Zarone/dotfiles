local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>p', builtin.git_files, {})

local actions = require('telescope.actions')
require("telescope").setup({
  pickers = {
    find_files = {
      initial_mode = "insert"
    }
  },
  defaults = {
    file_ignore_patterns = { "node_modules", "build", "bin", "dbt/target" },
    mappings = {
      n = {
        ["o"] = actions.select_default
      }
    },
  }
})
