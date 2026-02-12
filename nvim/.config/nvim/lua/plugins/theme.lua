return {
  "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = false
    vim.cmd.colorscheme("nord")

    -- Transparent background
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  end,
}
