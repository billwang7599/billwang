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
opt.showtabline = 2
opt.tabline = "%!v:lua.opencode_tabline()"

local function tabpage_var(tabpage, name)
  local ok, value = pcall(vim.api.nvim_tabpage_get_var, tabpage, name)
  if ok then
    return value
  end
end

local function short_name(path)
  path = path:gsub("^oil://", ""):gsub("/+$", "")
  local name = vim.fn.fnamemodify(path, ":t")
  return name ~= "" and name or path
end

local function tab_label(tabpage, tabnr)
  local history_commit = tabpage_var(tabpage, "git_history_commit")
  if history_commit then
    return "history:" .. history_commit:sub(1, 7)
  end

  local win = vim.api.nvim_tabpage_get_win(tabpage)
  local buf = vim.api.nvim_win_get_buf(win)
  local name = vim.api.nvim_buf_get_name(buf)

  if name ~= "" then
    return short_name(name)
  end

  return short_name(vim.fn.getcwd(-1, tabnr))
end

local function tab_modified(tabpage)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].modified then
      return "+"
    end
  end

  return ""
end

function _G.opencode_tabline()
  local current = vim.api.nvim_get_current_tabpage()
  local line = ""

  for tabnr, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    local hl = tabpage == current and "%#TabLineSel#" or "%#TabLine#"
    local marker = tab_modified(tabpage)
    local label = tab_label(tabpage, tabnr)

    line = line .. hl .. "%" .. tabnr .. "T " .. tabnr .. marker .. " " .. label .. " "
  end

  return line .. "%#TabLineFill#%T"
end

vim.api.nvim_set_hl(0, "TabLine", { fg = "#D8DEE9", bg = "#2E3440" })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#2E3440", bg = "#88C0D0", bold = true })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })

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

vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.diagnostic.config({
  virtual_text = true,
  float = { border = "rounded" },
})
