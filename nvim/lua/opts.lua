-- [[ Lazy.vim opts ]]

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
-- vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Custom options ]]
vim.opt.relativenumber = true -- show relative line number
vim.opt.shiftwidth = 4 -- sets tabstop to 4 on new files
vim.opt.scrolloff = 10 -- sets scrolloff to always show 10 lines above or below while scrolling if possible
vim.opt.tabstop = 4

-- [[ Extensions ]]
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
