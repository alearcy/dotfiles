{ config, pkgs, lib, inputs, ... }:

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
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/emacs/.emacs.d";
        recursive = true;
    };

    "./config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hypr/.config/hypr";
      recursive = true;
    };
    "./config/waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/waybar/.config/waybar";
      recursive = true;
   };
   "./config/kitty" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/kitty/.config/kitty";
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

  # App launcher
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Agave Nerd Font 13";
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
  in {
    "*" = {
      /* Solarized Light Colors with transparency */
      bg-col = mkLiteral "rgba(253, 246, 227, 0.70)";           /* base3 - background (95% opacity) */
      bg-col-light = mkLiteral "rgba(238, 232, 213, 0.70)";     /* base2 - background highlights (95% opacity) */
      border-col = mkLiteral "#93a1a1";                         /* base1 - optional emphasized content */
      selected-col = mkLiteral "#268bd2";                       /* blue - primary content */
      selected-bg = mkLiteral "rgba(238, 232, 213, 0.70)";      /* base2 - background highlights (95% opacity) */
      fg-col = mkLiteral "#657b83";                             /* base00 - body text / default code */
      fg-col2 = mkLiteral "#586e75";                            /* base01 - comments / secondary content */
      grey = mkLiteral "#93a1a1";                               /* base1 */
      
      width = 600;
    };
    
    "window" = {
      height = 360;
      border = mkLiteral "3px";
      border-color = mkLiteral "@grey";
      background-color = mkLiteral "@bg-col";
      border-radius = mkLiteral "8px";
    };
    
    "mainbox" = {
      background-color = mkLiteral "@bg-col";
      padding = mkLiteral "6px";
    };
    
    "inputbar" = {
      children = mkLiteral "[prompt,entry]";
      background-color = mkLiteral "@bg-col-light";
      border-radius = mkLiteral "6px";
      padding = mkLiteral "10px 12px";
      margin = mkLiteral "0px 0px 6px 0px";
      border = mkLiteral "1px";
      border-color = mkLiteral "@grey";
    };
    
    "prompt" = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@selected-col";
      margin = mkLiteral "0px 8px 0px 0px";
    };
    
    "entry" = {
      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@fg-col";
      placeholder-color = mkLiteral "@fg-col2";
    };
    
    "listview" = {
      border = mkLiteral "0px";
      padding = mkLiteral "0px";
      margin = mkLiteral "0px";
      columns = 1;
      lines = 8;
      background-color = mkLiteral "@bg-col";
      scrollbar = false;
      spacing = mkLiteral "1px";
    };
    
    "element" = {
      padding = mkLiteral "14px 16px";
      background-color = mkLiteral "@bg-col";
      text-color = mkLiteral "@fg-col";
      border-radius = mkLiteral "4px";
    };
    
    "element-icon" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
      size = mkLiteral "20px";
      margin = mkLiteral "0px 12px 0px 0px";
    };
    
    "element-text" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "inherit";
    };
    
    "element selected" = {
      background-color = mkLiteral "@selected-bg";
      text-color = mkLiteral "@selected-col";
    };

    /* Stili specifici per filebrowser */
    "filebrowser" = {
      background-color = mkLiteral "@bg-col";
    };

    /* Message bar */
    "message" = {
      background-color = mkLiteral "@bg-col-light";
      padding = mkLiteral "8px";
      margin = mkLiteral "0px 0px 6px 0px";
      border-radius = mkLiteral "4px";
    };
    
    "textbox" = {
      background-color = mkLiteral "inherit";
      text-color = mkLiteral "@fg-col2";
    };

    /* Path bar per filebrowser */
    "path-bar" = {
      background-color = mkLiteral "@bg-col-light";
      text-color = mkLiteral "@fg-col2";
      padding = mkLiteral "8px 12px";
      margin = mkLiteral "0px 0px 6px 0px";
      border-radius = mkLiteral "4px";
      border = mkLiteral "1px";
      border-color = mkLiteral "@grey";
    };

    "element.normal.file" = {
      background-color = mkLiteral "@bg-col";
      text-color = mkLiteral "@fg-col";
    };
    
    "element.selected.file" = {
      background-color = mkLiteral "@selected-bg";
      text-color = mkLiteral "@selected-col";
      border = mkLiteral "1px";
      border-color = mkLiteral "@selected-col";
    };
    
    "element.normal.directory" = {
      background-color = mkLiteral "@bg-col";
      text-color = mkLiteral "@selected-col";  /* Directory in blu */
    };
    
    "element.selected.directory" = {
      background-color = mkLiteral "@selected-bg";
      text-color = mkLiteral "@selected-col";
      border = mkLiteral "1px";
      border-color = mkLiteral "@selected-col";
    };
    
    "mode-switcher" = {
      spacing = mkLiteral "0px";
      margin = mkLiteral "4px 0px 0px 0px";
    };
    
    "button" = {
      padding = mkLiteral "6px 16px";
      background-color = mkLiteral "@bg-col-light";
      text-color = mkLiteral "@fg-col2";
      border-radius = mkLiteral "4px";
      margin = mkLiteral "0px 4px 0px 0px";
    };
    
    "button selected" = {
      background-color = mkLiteral "@selected-col";
      text-color = mkLiteral "@bg-col";
    };
  };
    extraConfig = {
      modi = "drun,run,filebrowser";
      show-icons = true;
      display-drun = " Apps";
      display-run = " Run";
      display-filebrowser = " Files";
      drun-display-format = "{name}";
      run-display-format = "{name}";
      filebrowser-display-format = "{name}";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  }
