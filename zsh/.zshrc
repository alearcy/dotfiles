fastfetch

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$PATH:$HOME/go/bin"
export PKG_CONFIG_PATH=/usr/lib/pkgconfig
export TERMINAL=kitty

alias i="paru -S"
alias s="paru -Ss"
alias u="paru -Rs"
alias md="mkdir -p"
alias rd="rm -rf"
alias grep="rg"
alias ls="eza -la --icons=always"
alias hx="helix"
alias tree="eza -T --git-ignore --icons"
alias cat="bat"
alias sudohx='EDITOR=helix sudoedit'
alias et='rm -rf ~/.local/share/Trash/*'

# command typo correction
setopt CORRECT

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Avvia Hyprland automaticamente su tty1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec Hyprland
fi
