return {
  "stevearc/oil.nvim",
  -- Optional dependency for file icons
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      -- Basic settings
      view_options = {
        show_hidden = true,
      },
      -- You can add more options here as needed
    })

    -- Open parent directory with '-'
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
