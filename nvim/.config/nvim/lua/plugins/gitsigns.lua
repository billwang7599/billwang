return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- Loads when you open a file
  config = function()
    require("gitsigns").setup({
      -- Visual settings (optional, defaults are usually fine)
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      
    })
  end,
}
