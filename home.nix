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
  home.packages = [
    pkgs.nerd-fonts.agave
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.kitty-themes
    pkgs.base16-schemes
    # Shell scripts
    (pkgs.writeShellScriptBin "aa" (builtins.readFile ./aa.sh) )
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "emacs";
    NIXOS_OZONE_WL = "1"; # Fix Electron problems with Hyprland
  };

  imports = [
    ./GUI/hyprland.nix
    ./GUI/waybar.nix
  ];

  programs.git = {
    enable = true;
    userName = "alearcy";
    userEmail = "arcidiaco.a@gmail.com";
  };

  programs.zsh = {
    enable = true;
    shellAliases.ll = "ls -la";
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "git-flow"];
      theme = "agnoster";
    };
  };

  fonts.fontconfig.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Agave Nerd Font Mono";
      size = 13;
    };
    settings = {
       window_padding_width = 8;
    };
    # Per un elenco completo: 
    # ls /nix/store/i9nddlyn2hfr48z7hrs8kkkhd5nhd2qb-kitty-themes-0-unstable-2024-08-14/share/kitty-themes/themes
    # themeFile = "GruvboxMaterialLightHard";
    themeFile = "Solarized_Light";
  };

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
    font = "Agave Nerd Font";
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

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.emacs.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
