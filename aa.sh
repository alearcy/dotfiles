#!/bin/bash
set -euo pipefail

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

FLAKE_DIR="$HOME/dotfiles"
USER="aa"
THEME_FILE="$HOME/.local/share/theme-state"

# Icons
apps_icon=$(printf "\U000f003b")
rebuild_icon=$(printf "\U000f145e")
update_icon=$(printf "\U000f06b0")
clean_icon=$(printf "\U000f00e2") 
full_update_icon=$(printf "\U000f0e7")
light_icon=$(printf "\U000f522")
dark_icon=$(printf "\U000f4ee")
lock_icon=$(printf "\U000f023")
logout_icon=$(printf "\U000f0343")
reboot_icon=$(printf "\U000f0709")
shutdown_icon=$(printf "\U000f011")

# Funzioni esistenti mantenute
check_flake_dir() {
  if [ ! -d "$FLAKE_DIR" ]; then
    notify-send "AA System" "Flake directory $FLAKE_DIR not found!" --urgency=critical
    exit 1
  fi
}

apply_theme() {
  local MODE="$1"
  local DOTFILES_PATH="$HOME/dotfiles"
  local conffile="$HOME/.config/mako/config"
  # Change bkg with swww
  if command -v swww >/dev/null; then
    case "$MODE" in
    "light")
       swww img $DOTFILES_PATH/light.png --transition-type=right --transition-step=10
       ;;
    "dark")
       swww img $DOTFILES_PATH/dark.jpg --transition-type=right --transition-step=10
       ;;
    esac
  fi
  
  sleep 1

  if command -v hyprpanel >/dev/null; then

    case "$MODE" in
    "light")
       hyprpanel ut ".config/hyprpanel/solarized.json" 
       ;;
    "dark")
       hyprpanel ut ".config/hyprpanel/nord.json" 
       ;;
    esac
  fi  
 
  # Mako theme colors
  # if command -v makoctl >/dev/null; then
  #   if [ -f "$conffile" ]; then
  #     declare -A colors
  #     case "$MODE" in
  #     "light")
  #       # Solarized Light colors
  #       colors=(
  #         ["background-color"]="#fdf6e3d9"
  #         ["text-color"]="#657b83"
  #         ["border-color"]="#93a1a1"
  #       )
  #       ;;
  #     "dark")
  #       # Nord colors
  #       colors=(
  #         ["background-color"]="#2e3440d9"
  #         ["text-color"]="#d8dee9"
  #         ["border-color"]="#5e81ac"
  #       )
  #       ;;
  #     esac

  #     for color_name in "${!colors[@]}"; do
  #       sed -i "0,/^$color_name.*/{s//$color_name=${colors[$color_name]}/}" "$conffile"
  #     done

  #     makoctl reload
  #   fi
  # fi

  # GTK theme
  if command -v gsettings >/dev/null; then
    if [ "$MODE" = "light" ]; then
      gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
      gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    else
      gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
      gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    fi
  fi

  sleep 1

  # Kitty automatically change theme based on system color scheme using light and dark css.
 
}

# Menu fuzzel principale
show_menu() {
  # Ottieni tema corrente per mostrarlo nel menu
  local current_theme="light"
  if [ -f "$THEME_FILE" ]; then
    current_theme=$(cat "$THEME_FILE")
  fi

  # Array di opzioni per maggiore chiarezza
  local menu_options=(
	 "${apps_icon} Apps"
	 "---"
    "${rebuild_icon} Rebuild System"
    "${update_icon} Update Flake"
    "${clean_icon} Clean Nix Store"
    "${full_update_icon} Full Update"
    "${light_icon} Light Theme"
    "${dark_icon} Dark Theme"
    "---"
    "${lock_icon} Lock Screen"
    "${logout_icon} Logout"
    "${reboot_icon} Reboot"
    "${shutdown_icon} Shutdown"
  )
  
  local options=$(printf '%s\n' "${menu_options[@]}")
  local lines_count=${#menu_options[@]}

  local chosen=$(echo "$options" | fuzzel --dmenu --prompt "Search: " --lines $lines_count)

  case "$chosen" in
	"${apps_icon} Apps")
		fuzzel
		;;
    "${rebuild_icon} Rebuild System")
      ${TERMINAL} --title "AA System - Rebuild" -e bash -c "
        echo -e '${CYAN}AA System - Rebuilding...${NC}'
        if [ ! -d '$FLAKE_DIR' ]; then
          echo -e '${RED}Flake directory $FLAKE_DIR not found!${NC}'
          read -p 'Press any key to continue...'
          exit 1
        fi
        sudo nixos-rebuild switch --flake '$FLAKE_DIR'
        echo -e '${GREEN}System rebuild completed!${NC}'
        notify-send 'AA System' 'System rebuild completed!' --urgency=low
        read -p 'Press any key to continue...'
      " &
      ;;
   "${update_icon} Update Flake")
      ${TERMINAL} --title "AA System - Update" -e bash -c "
        echo -e '${CYAN}AA System - Updating flake inputs...${NC}'
        cd '$FLAKE_DIR' && nix flake update
        echo -e '${GREEN}Flake update completed!${NC}'
        notify-send 'AA System' 'Flake update completed!' --urgency=low
        read -p 'Press any key to continue...'
      " &
      ;;
    "${clean_icon} Clean Nix Store")
      ${TERMINAL} --title "AA System - Clean" -e bash -c "
        echo -e '${CYAN}AA System - Cleaning Nix store...${NC}'
        nix-collect-garbage -d && sudo nix-collect-garbage -d
        echo -e '${GREEN}Cleanup completed!${NC}'
        notify-send 'AA System' 'Cleanup completed!' --urgency=low
        read -p 'Press any key to continue...'
      " &
      ;;
    "${full_update_icon} Full Update")
      ${TERMINAL} --title "AA System - Full Update" -e bash -c "
        echo -e '${CYAN}AA System - Starting full update...${NC}'
        cd '$FLAKE_DIR'
        echo -e '${YELLOW}Step 1/3: Updating flake...${NC}'
        nix flake update
        echo -e '${YELLOW}Step 2/3: Rebuilding system...${NC}'
        sudo nixos-rebuild switch --flake '$FLAKE_DIR'
        echo -e '${YELLOW}Step 3/3: Cleaning up...${NC}'
        nix-collect-garbage -d && sudo nix-collect-garbage -d
        echo -e '${GREEN}Full update completed!${NC}'
        notify-send 'AA System' 'Full update completed!' --urgency=low
        read -p 'Press any key to continue...'
      " &
      ;;
    "${light_icon} Light Theme")
      apply_theme "light"
      ;;
    "${dark_icon} Dark Theme")
      apply_theme "dark"
      ;;
    "${lock_icon} Lock Screen")
      hyprlock
      ;;
    "${logout_icon} Logout")
      hyprctl dispatch exit
      ;;
    "${reboot_icon} Reboot")
      systemctl reboot
      ;;
    "${shutdown_icon} Shutdown")
      systemctl poweroff
      ;;
      *)
      ;;
  esac
}

show_menu
