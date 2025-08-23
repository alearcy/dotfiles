{ config, pkgs, lib, themeMode, ... }:

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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    pkgs.nerd-fonts.agave
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.kitty-themes
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/aa/etc/profile.d/hm-session-vars.sh
  #
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
      name = lib.mkDefault "Agave Nerd Font Mono";
      size = lib.mkDefault 13;
    };
    settings = {
       window_padding_width = 8;
    };
    # Per un elenco completo: 
    # ls /nix/store/i9nddlyn2hfr48z7hrs8kkkhd5nhd2qb-kitty-themes-0-unstable-2024-08-14/share/kitty-themes/themes
    themeFile = "GruvboxMaterialLightHard";
  };
  
  stylix.enable = true;
  stylix.image = ./wallpaper.jpg;
  stylix.polarity = "light";
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    monospace = {
      package = pkgs.nerd-fonts.agave;
      name = "Agave Nerd Font Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  stylix.targets = {
    waybar.enable = false;
    kitty.enable = false;
    emacs.enable = false;
  };

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.emacs.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
