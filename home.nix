{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aa";
  home.homeDirectory = "/home/aa";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    (writeShellScriptBin "aa" (builtins.readFile ./aa.sh) )
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Emacs symlinks
    ".emacs.d" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/emacs/.emacs.d";
        recursive = true;
    };

    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hypr/.config/hypr";
      recursive = true;
    };
    ".config/waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/waybar/.config/waybar";
      recursive = true;
   };
   ".config/kitty" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kitty/.config/kitty";
      recursive = true;
    };
  };


home.activation.createThemeState = lib.hm.dag.entryAfter ["writeBoundary"] ''
  THEME_FILE="$HOME/.local/share/theme-state"
  
  # Rimuovi il symlink se esiste
  if [ -L "$THEME_FILE" ]; then
    rm "$THEME_FILE"
  fi
  
  # Crea il file normale se non esiste
  if [ ! -f "$THEME_FILE" ]; then
    mkdir -p "$(dirname "$THEME_FILE")"
    echo "light" > "$THEME_FILE"
    echo "✅ Created mutable theme-state file"
  fi
'';

home.activation.initTheme = lib.hm.dag.entryAfter ["createThemeState"] ''
  THEME_FILE="$HOME/.local/share/theme-state"
  
  if [ -f "$THEME_FILE" ] && [ ! -L "$THEME_FILE" ]; then
    THEME=$(cat "$THEME_FILE")
    echo "🎨 Applying theme: $THEME"
    aa "$THEME" || echo "⚠️ Theme application failed"
  fi
'';

  home.sessionVariables = {
    EDITOR = "emacs";
    NIXOS_OZONE_WL = "1"; # Fix Electron problems with Hyprland
  };
  
  programs.git = {
    enable = true;
    userName = "alearcy";
    userEmail = "arcidiaco.a@gmail.com";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "git-flow"];
      theme = "agnoster";
    };
  };

  fonts.fontconfig.enable = true;

  # Notifiche di sistema
  services.mako = {
    enable = true;
    width = 350;
    height = 120;
    margin = "20";
    padding = "15";
    defaultTimeout = 8000;
    groupBy = "summary";
    sort = "-time";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
