return {
  "Saghen/blink.cmp",
  -- This ensures the fuzzy engine is compiled on every update
  -- build = "cargo build --release", 
  -- If you don't have cargo installed, use the pre-built binaries instead:
  -- build = 'nix run .#build-plugin', 
  
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
