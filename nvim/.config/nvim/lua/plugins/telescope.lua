return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 
    'nvim-lua/plenary.nvim',
    -- Highly recommended: FZF native for better performance
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- Enable fzf native if installed
    telescope.load_extension('fzf')

    -- Keymaps
    local builtin = require('telescope.builtin')
    local keymap = vim.keymap -- for conciseness

    keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Fuzzy find files in cwd' })
    keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Fuzzy find recent files' })
    keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Find string in cwd' })
    keymap.set('n', '<leader>fc', builtin.grep_string, { desc = 'Find string under cursor' })
    keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'List open buffers' })
    keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'List help tags' })
  end
}
