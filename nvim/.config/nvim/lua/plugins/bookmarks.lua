return {
  "tomasky/bookmarks.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  event = "VimEnter",
  config = function()
    local bm = require("bookmarks")

    bm.setup({
      -- Repo-scoped bookmarks: saves in .git or cwd
      save_file = (function()
        local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
        if vim.v.shell_error == 0 and git_root ~= "" then
          return git_root .. "/.bookmarks"
        else
          return vim.fn.getcwd() .. "/.bookmarks"
        end
      end)(),
      sign_priority = 8,
      signs = {
        add = { hl = "BookMarksAdd", text = "⚑", numhl = "BookMarksAddNr", linehl = "BookMarksAddLn" },
        ann = { hl = "BookMarksAnn", text = "♥", numhl = "BookMarksAnnNr", linehl = "BookMarksAnnLn" },
      },
      keywords = {
        ["@t"] = "☑️ ", -- todo
        ["@w"] = "⚠️ ", -- warning
        ["@f"] = "⛏ ", -- fix
        ["@n"] = "📝 ", -- note
      },
    })

    -- Bookmark keymaps live in the Bookmarks Hydra (<leader>b) in hydra.lua

    -- Load telescope extension
    require("telescope").load_extension("bookmarks")
  end,
}
