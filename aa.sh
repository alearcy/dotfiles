#!/usr/bin/env bash
set -euo pipefail

# Colori per output (tuoi esistenti)
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

FLAKE_DIR="$HOME/dotfiles"
USER="aa"
THEME_FILE="$HOME/.local/share/theme-state"  # ← Cambiato qui

# Funzione show_help esistente - INVARIATA
show_help() {
  echo -e "${CYAN}AA - System Configuration Tool${NC}"
  echo -e "${BLUE}Usage: aa [COMMAND]${NC}"
  echo ""
  echo -e "${YELLOW}Available commands:${NC}"
  echo -e "  ${GREEN}rebuild${NC}      - Rebuild NixOS system configuration"
  echo -e "  ${GREEN}update${NC}       - Update flake inputs"
  echo -e "  ${GREEN}clean${NC}        - Clean up Nix store (garbage collection)"
  echo -e "  ${GREEN}full${NC}         - Update + Rebuild system + Clean"
  echo -e "  ${GREEN}light${NC}        - Switch to light theme (and remember it)"
  echo -e "  ${GREEN}dark${NC}         - Switch to dark theme (and remember it)"
  echo -e "  ${GREEN}toggle${NC}       - Toggle between light and dark"
  echo -e "  ${GREEN}theme${NC}        - Show current theme mode"
  echo -e "  ${GREEN}help${NC}         - Show this help message"
  echo ""
  echo -e "${PURPLE}Examples:${NC}"
  echo -e "  aa rebuild"
  echo -e "  aa dark"
  echo -e "  aa toggle"
  echo -e "  aa theme"
}

# Funzioni rebuild, update, clean, full - INVARIATE
check_flake_dir() {
  if [ ! -d "$FLAKE_DIR" ]; then
    echo -e "${RED}Flake directory $FLAKE_DIR not found!${NC}"
    exit 1
  fi
}

# Funzione apply_theme - AGGIORNATA per usare il nuovo file
apply_theme() {
  local MODE="$1"
  local DOTFILES_PATH="$HOME/dotfiles"  # Corretto path

  echo -e "${BLUE}Applying $MODE theme...${NC}"

  # Kitty theme
  if command -v kitten >/dev/null; then
    case "$MODE" in
      "light")
        kitten themes --reload-in=all "Modus Operandi Tinted"
        echo -e "${YELLOW}Applied Kitty theme: Modus Operandi Tinted${NC}"
        ;;
      "dark")
        kitten themes --reload-in=all "Modus Vivendi Tinted"
        echo -e "${YELLOW}Applied Kitty theme: Modus Vivendi Tinted${NC}"
        ;;
    esac
  else
    echo -e "${RED}Warning: kitten not found${NC}"
  fi

  # Waybar theme
  if [ -f "$DOTFILES_PATH/waybar/style-${MODE}.css" ]; then
    cp "$DOTFILES_PATH/waybar/style-${MODE}.css" "$HOME/.config/waybar/style.css"
    echo -e "${YELLOW}Applied waybar theme: ${MODE}${NC}"
    
    # Riavvia waybar
    if pgrep waybar >/dev/null; then
      pkill waybar && sleep 0.5 && waybar &
      echo -e "${YELLOW}Waybar restarted${NC}"
    fi
  else
    echo -e "${RED}Warning: waybar style-${MODE}.css not found${NC}"
  fi

  # GTK theme
  if command -v gsettings >/dev/null; then
    if [ "$MODE" = "light" ]; then
      gsettings set org.gnome.desktop.interface color-scheme "default"
      gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    else
      gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
      gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    fi
    echo -e "${YELLOW}Applied GTK theme: ${MODE}${NC}"
  fi

  echo -e "${GREEN}Theme $MODE succesfully applied${NC}"
}

# Funzione switch_theme - AGGIORNATA per salvare nel nuovo file
switch_theme() {
  local MODE="$1"
  case "$MODE" in
    light|dark)
      # Salva lo stato nel file theme-state
      echo "$MODE" > "$THEME_FILE"
      apply_theme "$MODE"
      ;;
    *)
      echo -e "${RED}Invalid theme: $MODE (use light or dark)${NC}"
      exit 1
      ;;
  esac
}

# Funzione toggle - AGGIORNATA per leggere dal nuovo file
toggle_theme() {
  local CURRENT="light"
  if [ -f "$THEME_FILE" ]; then
    CURRENT=$(cat "$THEME_FILE")
  fi
  if [ "$CURRENT" = "light" ]; then
    switch_theme "dark"
  else
    switch_theme "light"
  fi
}

# Funzione show_theme - AGGIORNATA per leggere dal nuovo file
show_theme() {
  if [ -f "$THEME_FILE" ]; then
    local current=$(cat "$THEME_FILE")
    echo -e "${CYAN}Current theme:${NC} ${GREEN}$current${NC}"
  else
    echo -e "${YELLOW}No theme file found. Using default: light${NC}"
  fi
}

# Main logic - INVARIATO (mantiene help come default)
case "${1:-help}" in
  "rebuild"|"r")
    check_flake_dir; sudo nixos-rebuild switch --flake "$FLAKE_DIR"
    ;;
  "update"|"u")
    check_flake_dir; nix flake update
    ;;
  "clean"|"c")
    nix-collect-garbage -d && sudo nix-collect-garbage -d
    ;;
  "full"|"f")
    check_flake_dir; nix flake update && sudo nixos-rebuild switch --flake "$FLAKE_DIR" && nix-collect-garbage -d && sudo nix-collect-garbage -d
    ;;
  "light"|"dark")
    switch_theme "$1"
    ;;
  "toggle")
    toggle_theme
    ;;
  "theme"|"t")
    show_theme
    ;;
  "help"|"--help"|"-h"|*)
    show_help
    ;;
esac
