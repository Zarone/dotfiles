local function open_reading_list()
  -- path to your Go file; change if you compiled the binary
  local go_file = vim.fn.expand("~/dotfiles/nvim/lua/plugins/cal/main.go")
  local run_cmd = {"go", "run", go_file}

  -- Start job attached to Neovim; when nvim quits, job is killed
  vim.fn.jobstart(run_cmd, {
    detach = false,
    on_stdout = function(_, data, _)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then print("[reading-list]", line) end
        end
      end
    end,
    on_stderr = function(_, data, _)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then print("[err reading-list]", line) end
        end
      end
    end,
    stdout_buffered = true,
  })

  vim.fn.system("sleep 0.5")

  -- give it a moment to start
  vim.defer_fn(function()
    local open_cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
    vim.fn.jobstart({open_cmd, "http://127.0.0.1:5002"}, {detach = true})
  end, 500)
end

vim.keymap.set("n", "<leader>c", open_reading_list, {desc = "Open to do list web UI"})
