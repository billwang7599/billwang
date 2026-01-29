# good packages (MACOS)
# install brew here 
brew install stow 
brew install lazygit

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
stow tmux

# nvim
brew install nvim
# run some command to ensure all dependancies for neovim packages are installed
brew install fd rg
stow nvim



