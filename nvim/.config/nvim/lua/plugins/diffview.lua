return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = { "<leader>g" },
  opts = {
    use_icons = true,
    diff_binaries = false,
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
  },
}
