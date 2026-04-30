return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
  opts = {
    size = 20,
    direction = "float",
    float_opts = {
      border = "rounded",
      width = function() return math.floor(vim.o.columns * 0.8) end,
      height = function() return math.floor(vim.o.lines * 0.8) end,
    },
  },
}
