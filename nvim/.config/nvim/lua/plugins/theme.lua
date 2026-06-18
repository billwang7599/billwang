return {
  "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = false
    -- subtle dark bg for diffs instead of full-line reverse-video green/red
    vim.g.nord_uniform_diff_background = true
    vim.cmd.colorscheme("nord")

    -- Transparent background
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })

    -- Diffs: background-only tints so LSP/treesitter/syntax colors stay visible.
    -- Native diff colors the whole line; we never set fg, so text keeps its real
    -- highlighting. (number-column-only isn't possible in native diff mode.)
    local hl = vim.api.nvim_set_hl
    hl(0, "DiffAdd", { bg = "#36402f", fg = "NONE" })    -- added line: faint green
    hl(0, "DiffChange", { bg = "#33384a", fg = "NONE" }) -- changed line: faint blue
    hl(0, "DiffText", { bg = "#3b4a63", fg = "NONE" })   -- exact changed text: stronger blue
    hl(0, "DiffDelete", { fg = "#bf616a", bg = "NONE" }) -- filler: red hatch (nord11), no fill

    -- diagonal hatch for empty filler instead of a wall of red dashes
    vim.opt.fillchars:append({ diff = "╱" })
  end,
}
