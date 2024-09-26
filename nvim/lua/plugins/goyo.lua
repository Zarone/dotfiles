_G.goyo = {}

-- Define the GoyoEnter function
function goyo.enter()
  vim.cmd 'colorscheme eink'
  vim.o.background = 'light'
  vim.opt.showmode = false
  vim.opt.scrolloff = 1
  vim.cmd('setlocal spell spelllang=en_us ')
  vim.o.smoothscroll = true
  vim.cmd("Limelight")
  if require('lualine') then
    require('lualine').hide({
      unhide = false,
      place = { "statusline" }
    })
  end
end

-- Define the GoyoLeave function
function goyo.leave()
  vim.cmd('setlocal spell!')
  vim.o.background = 'dark'
  vim.opt.showmode = true
  vim.opt.scrolloff = 5
  vim.o.smoothscroll = false
  vim.cmd("Limelight!")
  if require('lualine') then
    require('lualine').hide({
      unhide = true
    })
  end
end

-- Set up autocmd events to call the Lua functions on GoyoEnter and GoyoLeave
vim.cmd([[autocmd! User GoyoEnter nested lua goyo.enter()]])
vim.cmd([[autocmd! User GoyoLeave nested lua goyo.leave()]])
