return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
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
          find_command = { "/opt/homebrew/bin/fd", "--type", "f", "--hidden", "--no-ignore", "--exclude", ".git" }
        },
      },
    })

    -- Enable fzf native if installed
    telescope.load_extension('fzf')

    -- Keymaps
    local builtin = require('telescope.builtin')
    local keymap = vim.keymap

    -- Standard find files (now uses the custom fd command from pickers)
    keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files (inc. hidden/ignored, excl. .git)' })
    keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Fuzzy find recent files' })
    
    -- Text search (now uses the custom rg arguments from defaults)
    keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Find string (inc. hidden/ignored, excl. .git)' })
    keymap.set('n', '<leader>fc', builtin.grep_string, { desc = 'Find string under cursor' })
    
    keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'List open buffers' })
    keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'List help tags' })
  end
}
