#!/usr/bin/env bash
set -euo pipefail

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

FLAKE_DIR="$HOME/.dotfiles"
USER="alearcy"

# Funzione per mostrare l'help
show_help() {
  echo -e "${CYAN}AA - System Configuration Tool${NC}"
  echo -e "${BLUE}Usage: aa [COMMAND]${NC}"
  echo ""
  echo -e "${YELLOW}Available commands:${NC}"
  echo -e "  ${GREEN}rebuild${NC}      - Rebuild NixOS system configuration"
  echo -e "  ${GREEN}update${NC}       - Update flake inputs"
  echo -e "  ${GREEN}clean${NC}        - Clean up Nix store (garbage collection)"
  echo -e "  ${GREEN}full${NC}         - Update + Rebuild system + Clean"
  echo -e "  ${GREEN}help${NC}         - Show this help message"
  echo ""
  echo -e "${PURPLE}Examples:${NC}"
  echo -e "  aa rebuild"
  echo -e "  aa full"
  echo -e "  aa help"
}

# Funzione per verificare la directory del flake
check_flake_dir() {
  if [ ! -d "$FLAKE_DIR" ]; then
    echo -e "${RED}Flake directory $FLAKE_DIR not found!${NC}"
    exit 1
  fi
}

# Funzione per rebuild NixOS
rebuild_nixos() {
  echo -e "${BLUE}Rebuilding NixOS configuration...${NC}"
  check_flake_dir
  cd "$FLAKE_DIR"
  
  if sudo nixos-rebuild switch --flake .; then
    echo -e "${GREEN}NixOS rebuild completed successfully!${NC}"
  else
    echo -e "${RED}NixOS rebuild failed!${NC}"
    exit 1
  fi
}

# Funzione per update flake
update_flake() {
  echo -e "${BLUE}Updating flake inputs...${NC}"
  check_flake_dir
  cd "$FLAKE_DIR"
  
  if nix flake update; then
    echo -e "${GREEN}Flake update completed successfully!${NC}"
  else
    echo -e "${RED}Flake update failed!${NC}"
    exit 1
  fi
}

# Funzione per cleanup
cleanup_nix() {
  echo -e "${BLUE}Cleaning up Nix store...${NC}"
  
  echo -e "${YELLOW}Running user garbage collection...${NC}"
  if nix-collect-garbage -d; then
    echo -e "${GREEN}User cleanup completed!${NC}"
  else
    echo -e "${RED}User cleanup failed!${NC}"
  fi
  
  echo -e "${YELLOW}Running system garbage collection...${NC}"
  if sudo nix-collect-garbage -d; then
    echo -e "${GREEN}System cleanup completed!${NC}"
  else
    echo -e "${RED}System cleanup failed!${NC}"
  fi
  
  echo -e "${BLUE}📊 Disk usage after cleanup:${NC}"
  df -h /nix/store | tail -1
}

# Funzione per full update
full_update() {
  echo -e "${PURPLE}Starting full system update...${NC}"
  echo ""
  
  update_flake
  echo ""
  
  rebuild_nixos
  echo ""
  
  cleanup_nix
  echo ""
  
  echo -e "${GREEN}Full system update completed successfully!${NC}"
}

# Main logic
case "${1:-help}" in
  "rebuild"|"r")
    rebuild_nixos
    ;;
  "update"|"u")
    update_flake
    ;;
  "clean"|"c")
    cleanup_nix
    ;;
  "full"|"f")
    full_update
    ;;
  "help"|"--help"|"-h"|*)
    show_help
    ;;
esac
