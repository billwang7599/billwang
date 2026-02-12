# good packages (MACOS)
# install brew here
brew install stow
brew install git
brew install lazygit

# tmux
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
stow tmux
# run prefix + I in tmux to install plugins

# nvim
brew install nvim
brew install fd rg
# treesitter & telescope-fzf-native need a C compiler
xcode-select --install
# node required for many LSP servers (pyright, ts_ls, html, css, json, yaml, bash)
brew install node
# optional language runtimes for LSP (uncomment as needed)
# brew install go
# brew install python
# brew install rustup && rustup-init
# brew install ruby
stow nvim



