#!/bin/bash

# good packages (MACOS)
# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew is not installed." >&2
    echo "Please install it first by running:" >&2
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' >&2
    exit 1
fi

command -v stow &>/dev/null || brew install stow
command -v git &>/dev/null || brew install git
command -v lazygit &>/dev/null || brew install lazygit
command -v cargo &>/dev/null || brew install rust

# tmux
command -v tmux &>/dev/null || brew install tmux
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
stow tmux
# run prefix + I in tmux to install plugins

# nvim
command -v nvim &>/dev/null || brew install nvim
command -v fd &>/dev/null || brew install fd
command -v rg &>/dev/null || brew install rg
command -v glow &>/dev/null || brew install glow
# treesitter & telescope-fzf-native need a C compiler
xcode-select -p &>/dev/null || xcode-select --install
# node required for many LSP servers (pyright, ts_ls, html, css, json, yaml, bash)
command -v node &>/dev/null || brew install node
# optional language runtimes for LSP (uncomment as needed)
# command -v go &>/dev/null || brew install go
# command -v python3 &>/dev/null || brew install python
# command -v rustup &>/dev/null || (brew install rustup && rustup-init)
# command -v ruby &>/dev/null || brew install ruby
stow nvim
stow ghostty

# opencode
command -v opencode &>/dev/null || brew install sst/tap/opencode
stow opencode

# custom scripts - add to PATH
grep -q 'billwang/scripts' ~/.zshrc || echo 'export PATH="$HOME/billwang/scripts:$PATH"' >> ~/.zshrc
