-- Get lazy if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- just use opt
local opt = vim.opt
opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- Initialize lazy.nvim with your plugin list
require("lazy").setup("plugins")

opt.relativenumber = true
opt.number = true

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true
opt.fillchars = { eob = " " }

-- Behavior
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"
opt.autoread = true

-- Copy file paths
vim.keymap.set("n", "cd", function()
  local path = vim.fn.expand("%:p:h")
  vim.fn.setreg("+", path)
  print("Copied directory: " .. path)
end, { noremap = true, silent = true, desc = "Copy file directory path" })

vim.keymap.set("n", "cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("Copied filepath: " .. path)
end, { noremap = true, silent = true, desc = "Copy full file path" })

