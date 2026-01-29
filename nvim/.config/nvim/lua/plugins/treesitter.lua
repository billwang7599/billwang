return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.config').setup({
      ensure_installed = {
        'c',
        'cpp',
        'go',
        'lua',
        'python',
        'rust',
        'ruby',
        'typescript',
        'javascript',
        'html',
        'css',
        'json',
        'yaml',
        'bash',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      select = {
          enable = true,
          keymaps = {
            ["af"] = "@function.outer", -- Select 'around function'
            ["if"] = "@function.inner", -- Select 'inside function'
          },
        },
    })
  end,
}
