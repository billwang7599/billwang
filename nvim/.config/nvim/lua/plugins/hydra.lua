return {
  "nvimtools/hydra.nvim",
  keys = { "<leader>w", "<leader>f", "<leader>r", "<leader>e" },
  config = function()
    local Hydra = require("hydra")

    Hydra({
      name = "Windows",
      mode = "n",
      body = "<leader>w",
      heads = {
        { "h", "<C-w>h", { desc = "move left" } },
        { "j", "<C-w>j", { desc = "move down" } },
        { "k", "<C-w>k", { desc = "move up" } },
        { "l", "<C-w>l", { desc = "move right" } },

        { "H", "<cmd>vertical resize -3<cr>", { desc = "resize left" } },
        { "J", "<cmd>resize -3<cr>", { desc = "resize down" } },
        { "K", "<cmd>resize +3<cr>", { desc = "resize up" } },
        { "L", "<cmd>vertical resize +3<cr>", { desc = "resize right" } },

        { "d", "<cmd>vsplit<cr>", { desc = "vsplit" } },
        { "D", "<cmd>split<cr>", { desc = "hsplit" } },

        { "t", "<cmd>terminal<cr>i", { exit = true, desc = "terminal" } },
        { "=", "<C-w>=", { desc = "equalize" } },
        { "q", "<cmd>close<cr>", { desc = "close" } },

        { "w", nil, { exit = true, desc = false } },
        { "<Esc>", nil, { exit = true, desc = false } },
      },
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          position = "bottom-right",
          border = "rounded",
        },
      },
    })
    Hydra({
      name = "Find",
      mode = "n",
      body = "<leader>f",
      heads = {
        { "f", "<cmd>Telescope find_files<cr>", { exit = true, desc = "files" } },
        { "s", "<cmd>Telescope live_grep<cr>", { exit = true, desc = "string" } },
        { "c", "<cmd>Telescope grep_string<cr>", { exit = true, desc = "under cursor" } },
        { "r", "<cmd>Telescope oldfiles<cr>", { exit = true, desc = "recent" } },
        { "b", "<cmd>Telescope buffers<cr>", { exit = true, desc = "buffers" } },
        { "h", "<cmd>Telescope help_tags<cr>", { exit = true, desc = "help" } },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          position = "bottom-right",
          border = "rounded",
        },
      },
    })
    Hydra({
      name = "Replace",
      mode = "n",
      body = "<leader>r",
      heads = {
        { "r", '<cmd>lua require("spectre").toggle()<cr>', { exit = true, desc = "open spectre" } },
        { "w", '<cmd>lua require("spectre").open_visual({select_word=true})<cr>', { exit = true, desc = "current word" } },
        { "f", '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>', { exit = true, desc = "current file" } },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          position = "bottom-right",
          border = "rounded",
        },
      },
    })
    Hydra({
      name = "LSP",
      mode = "n",
      body = "<leader>e",
      heads = {
        { "d", vim.diagnostic.open_float, { exit = true, desc = "line diagnostic" } },
        { "r", vim.lsp.buf.references, { exit = true, desc = "references" } },
        { "D", vim.lsp.buf.declaration, { exit = true, desc = "declaration" } },
        { "i", vim.lsp.buf.implementation, { exit = true, desc = "implementation" } },
        { "n", vim.lsp.buf.rename, { exit = true, desc = "rename" } },
        { "a", vim.lsp.buf.code_action, { exit = true, desc = "code action" } },
        { "s", vim.lsp.buf.signature_help, { exit = true, desc = "signature" } },
        { "f", function() vim.lsp.buf.format({ async = true }) end, { exit = true, desc = "format" } },
        { "[", vim.diagnostic.goto_prev, { desc = "prev diagnostic" } },
        { "]", vim.diagnostic.goto_next, { desc = "next diagnostic" } },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          position = "bottom-right",
          border = "rounded",
        },
      },
    })
  end,
}
