return {
  "nvimtools/hydra.nvim",
  keys = { "<leader>w", "<Tab>", "<leader><Tab>", "<leader>f", "<leader>r", "<leader>e", "<leader>g", "<leader>b" },
  config = function()
    local Hydra = require("hydra")
    local git_history_group = vim.api.nvim_create_augroup("GitHistoryWorktreeCleanup", { clear = true })

    local lazygit_term
    local function open_lazygit()
      require("lazy").load({ plugins = { "toggleterm.nvim" } })

      local Terminal = require("toggleterm.terminal").Terminal
      if not lazygit_term then
        lazygit_term = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
      end

      lazygit_term:toggle()
    end

    local function cleanup_history_worktree(root, path)
      if not root or not path or vim.fn.isdirectory(path) == 0 then
        return
      end

      vim.fn.jobstart({ "git", "-C", root, "worktree", "remove", "--force", path }, { detach = true })
    end

    vim.api.nvim_create_autocmd("TabClosedPre", {
      group = git_history_group,
      callback = function()
        cleanup_history_worktree(vim.t.git_history_root, vim.t.git_history_worktree)
      end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = git_history_group,
      callback = function()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          local has_root, root = pcall(vim.api.nvim_tabpage_get_var, tab, "git_history_root")
          local has_path, path = pcall(vim.api.nvim_tabpage_get_var, tab, "git_history_worktree")

          if has_root and has_path then
            cleanup_history_worktree(root, path)
          end
        end
      end,
    })

    local function get_git_root()
      local root = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
      if vim.v.shell_error ~= 0 or not root or root == "" then
        vim.notify("Not inside a git repository", vim.log.levels.ERROR)
        return nil
      end

      return root
    end

    local function open_history_worktree(root, commit, display)
      local base = vim.fn.stdpath("cache") .. "/git-history-worktrees"
      local repo = vim.fn.fnamemodify(root, ":t")
      local short = commit:sub(1, 7)
      local path = string.format("%s/%s-%s-%d", base, repo, short, os.time())

      vim.fn.mkdir(base, "p")

      local output = vim.fn.system({ "git", "-C", root, "worktree", "add", "--detach", path, commit })
      if vim.v.shell_error ~= 0 then
        vim.notify(vim.trim(output), vim.log.levels.ERROR)
        return
      end

      vim.cmd("tabnew")
      vim.cmd("tcd " .. vim.fn.fnameescape(path))
      vim.cmd("edit " .. vim.fn.fnameescape(path))

      vim.t.git_history_root = root
      vim.t.git_history_worktree = path
      vim.t.git_history_commit = commit

      vim.notify("Viewing " .. (display or short) .. ". Closing this tab removes the temp worktree.", vim.log.levels.INFO)
    end

    local function open_git_history()
      require("lazy").load({ plugins = { "telescope.nvim" } })

      local root = get_git_root()
      if not root then
        return
      end

      local lines = vim.fn.systemlist({ "git", "-C", root, "log", "--date=short", "--pretty=format:%H%x1f%h%x1f%ad%x1f%s" })
      if vim.v.shell_error ~= 0 then
        vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR)
        return
      end

      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local conf = require("telescope.config").values

      pickers.new({}, {
        prompt_title = "Git History",
        finder = finders.new_table({
          results = lines,
          entry_maker = function(line)
            local parts = vim.split(line, "\31", { plain = true })
            local commit = parts[1]
            local short = parts[2] or commit:sub(1, 7)
            local date = parts[3] or ""
            local subject = parts[4] or ""
            local display = string.format("%s  %s  %s", short, date, subject)

            return {
              value = commit,
              display = display,
              ordinal = display .. " " .. commit,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)

            if selection then
              open_history_worktree(root, selection.value, selection.display)
            end
          end)

          return true
        end,
      }):find()
    end

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
        },
      },
    })
    local tabs_hydra = Hydra({
      name = "Tabs",
      mode = "n",
      body = "<Tab>",
      heads = {
        { "h", "<cmd>tabprevious<cr>", { desc = "prev" } },
        { "l", "<cmd>tabnext<cr>", { desc = "next" } },
        { "H", "<cmd>tabmove -<cr>", { desc = "move left" } },
        { "L", "<cmd>tabmove +<cr>", { desc = "move right" } },
        { "n", "<cmd>tabnew<cr><cmd>Telescope find_files<cr>", { exit = true, desc = "new" } },
        { "q", "<cmd>tabclose<cr>", { exit = true, desc = "close" } },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          position = "bottom-right",
        },
      },
    })
    vim.keymap.set("n", "<leader><Tab>", function()
      tabs_hydra:activate()
    end, { desc = "Tabs hydra" })
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
        },
      },
    })
    Hydra({
      name = "Git",
      mode = "n",
      body = "<leader>g",
      heads = {
        { "s", "<cmd>Git<cr>", { exit = true, desc = "status" } },
        { "b", "<cmd>Git blame<cr>", { exit = true, desc = "blame" } },
        { "l", open_lazygit, { exit = true, desc = "lazygit" } },
        { "d", "<cmd>DiffviewOpen HEAD~1..HEAD<cr>", { exit = true, desc = "diff" } },
        { "h", open_git_history, { exit = true, desc = "history" } },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          position = "bottom-right",
        },
      },
    })
    Hydra({
      name = "Bookmarks",
      mode = "n",
      body = "<leader>b",
      heads = {
        { "x", function() require("bookmarks").bookmark_toggle() end, { desc = "toggle" } },
        { "a", function() require("bookmarks").bookmark_ann() end, { exit = true, desc = "annotate" } },
        { "n", function() require("bookmarks").bookmark_next() end, { desc = "next" } },
        { "p", function() require("bookmarks").bookmark_prev() end, { desc = "prev" } },
        { "m", "<cmd>Telescope bookmarks list<cr>", { exit = true, desc = "list" } },
        { "c", function() require("bookmarks").bookmark_clean() end, { exit = true, desc = "clean buffer" } },
        { "C", function() require("bookmarks").bookmark_clear_all() end, { exit = true, desc = "clear all" } },

        { "<Esc>", nil, { exit = true, desc = false } },
      },
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          position = "bottom-right",
        },
      },
    })
  end,
}
