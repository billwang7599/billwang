#!/bin/bash
# Bootstrap: install tools + stow dotfiles into $HOME. Idempotent / safe to re-run.

# Safety rails: error on unset vars + failed pipes. (NOT `set -e` on purpose —
# a single stow conflict or `xcode-select --install` returning non-zero must
# not abort the whole bootstrap.)
set -uo pipefail
# Always run from the repo root so `stow <pkg>` resolves no matter the CWD.
cd "$(dirname "${BASH_SOURCE[0]}")"

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

# terminal niceties: prompt, colours, fuzzy-find, smart-cd, syntax highlight
command -v starship &>/dev/null || brew install starship
command -v eza       &>/dev/null || brew install eza
command -v bat       &>/dev/null || brew install bat
command -v delta     &>/dev/null || brew install git-delta
command -v fzf       &>/dev/null || brew install fzf
command -v zoxide    &>/dev/null || brew install zoxide
brew list zsh-autosuggestions     &>/dev/null || brew install zsh-autosuggestions
brew list zsh-syntax-highlighting &>/dev/null || brew install zsh-syntax-highlighting
# Nerd Font so the Starship prompt + eza icons render in Ghostty
brew list --cask font-meslo-lg-nerd-font &>/dev/null || brew install --cask font-meslo-lg-nerd-font
stow zsh
# make ~/.zshrc source the niceties (idempotent)
grep -q '.config/zsh/niceties.zsh' ~/.zshrc 2>/dev/null \
  || echo '[ -r ~/.config/zsh/niceties.zsh ] && source ~/.config/zsh/niceties.zsh' >> ~/.zshrc

# git-delta: pretty, colourful git diffs (idempotent)
if command -v delta &>/dev/null; then
  # ~/.gitconfig may be root-owned (git-ai installer); take ownership so `git config` works
  if [ -f ~/.gitconfig ] && [ ! -O ~/.gitconfig ]; then
    sudo chown "$(id -un)":staff ~/.gitconfig
  fi
  if [ "$(git config --global core.pager 2>/dev/null)" != "delta" ]; then
    git config --global core.pager "delta"
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.line-numbers true
    git config --global merge.conflictStyle zdiff3
  fi
fi

# custom scripts - add to PATH
grep -q 'billwang/scripts' ~/.zshrc || echo 'export PATH="$HOME/billwang/scripts:$PATH"' >> ~/.zshrc
