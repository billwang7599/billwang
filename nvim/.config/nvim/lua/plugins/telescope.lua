return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  dependencies = { 
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        -- Configuration for 'live_grep' and 'grep_string'
        -- This tells ripgrep to show hidden and ignored files, but skip .git
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--no-ignore",
          "--glob", "!.git/*",
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          -- Configuration for 'find_files'
          -- Uses 'fd' to find everything (hidden/ignored) but excludes .git
          find_command = { "/opt/homebrew/bin/fd", "--type", "f", "--hidden", "--no-ignore", "--exclude", ".git" },
          cwd_only = true,
        },
        live_grep = {
          cwd_only = true,
        },
        grep_string = {
          cwd_only = true,
        },
        oldfiles = {
          cwd_only = true,
        },
      },
    })

    telescope.load_extension('fzf')
  end
}
