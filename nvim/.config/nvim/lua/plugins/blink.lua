return {
  "Saghen/blink.cmp",
  version = "*",
  build = "cargo build --release",
  
  opts = {
    -- your blink.cmp options here
    keymap = {
      preset = 'enter', -- or 'super-tab' / 'enter'

      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
    },
    -- If too slow, switch to rust
     fuzzy = {
     implementation = "lua"
     }
  }
}
