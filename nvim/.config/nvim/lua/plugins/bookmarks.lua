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

    -- Global keymaps
    vim.keymap.set("n", "<leader>bx", bm.bookmark_toggle, { desc = "Bookmark toggle" })
    vim.keymap.set("n", "<leader>ba", bm.bookmark_ann, { desc = "Bookmark annotate" })
    vim.keymap.set("n", "<leader>bn", bm.bookmark_next, { desc = "Bookmark next" })
    vim.keymap.set("n", "<leader>bp", bm.bookmark_prev, { desc = "Bookmark prev" })
    vim.keymap.set("n", "<leader>bm", "<cmd>Telescope bookmarks list<cr>", { desc = "Bookmark list" })
    vim.keymap.set("n", "<leader>bc", bm.bookmark_clean, { desc = "Bookmark clean (buffer)" })
    vim.keymap.set("n", "<leader>bC", bm.bookmark_clear_all, { desc = "Bookmark clear all" })

    -- Load telescope extension
    require("telescope").load_extension("bookmarks")
  end,
}
