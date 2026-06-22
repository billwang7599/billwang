# ============================================================
# Terminal niceties  (stow package: zsh -> ~/.config/zsh/niceties.zsh)
# Sourced from ~/.zshrc. Every line is guarded so a missing tool
# never errors or blocks shell startup. (idempotent / footgun-proof)
# ============================================================

# --- Starship prompt: repo / git branch / dirty state / colour ---
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- zoxide: smarter cd. `z <partial-dir>` jumps, `zi` picks. (cd untouched) ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# --- fzf: Ctrl-R fuzzy history, Ctrl-T files, Alt-C cd ---
command -v fzf >/dev/null && source <(fzf --zsh)

# --- eza: colourful ls. NOTE: shadows `ls`. Comment the alias to restore /bin/ls ---
if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --git --group-directories-first'
  alias la='eza -a  --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
fi

# --- bat: syntax-highlighted viewer. Deliberately NOT aliased over `cat`
#     (bat isn't a true cat: breaks `cat -A`, heredocs, etc).
#     Use `bat file`, or the short `c file`. Real `cat` stays intact. ---
command -v bat >/dev/null && alias c='bat --paging=never'

# --- zsh plugins (homebrew). Syntax-highlighting MUST be sourced last. ---
_brew_share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"
[ -r "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] \
  && source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -r "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] \
  && source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _brew_share
