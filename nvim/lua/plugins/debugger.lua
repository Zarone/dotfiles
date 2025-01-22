require("telescope").load_extension("dap")
local dap, dapui = require("dap"), require("dapui")
require('dap-python').setup('/opt/homebrew/bin/python')

require("nvim-dap-virtual-text").setup({
  commented = true,
})

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>", "o" },
    repl = "r",
  },
  layouts = {
    {
      elements = {
        "watches",
        { id = "scopes", size = 0.70 },
        { id = "stacks", size = 0.15 }
      },
      size = 30,
      position = "left",
    },
    {
      elements = {
          "repl",
      },
      size = 0.25,
      position = "bottom",
    },
    controls = {
      enabled = true,
      element = "repl",
    }
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "double", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 1, -- Can be integer or nil.
  }
})

vim.fn.sign_define(
    "DapBreakpoint",
    { text = "♥️", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "🔶", texthl = "", linehl = "debugBreakpoint", numhl = "debugBreakpoint" }
)
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "", linehl = "debugPC", numhl = "debugPC" })
dap.defaults.fallback.force_external_terminal = true

vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
vim.keymap.set('n', '<F12>', dap.step_out)
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>d', ":Telescope dap commands<CR>")

local install_root_dir = vim.fn.stdpath("data") .. "/mason"
local extension_path = install_root_dir .. "/packages/codelldb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
    args = { "--port", "${port}" },
  },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = true,
  },
}

dap.configurations.c = dap.configurations.cpp

dap.configurations.python = {
  {
    type = "python",
    name = "debug main",
    request = "launch",
    program = "./main.py",
  },
}

