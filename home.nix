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
    ".emacs.d" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/emacs/.emacs.d";
        recursive = true;
    };
    ".config/hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hypr/.config/hypr";
      recursive = true;
    };
   ".config/kitty" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kitty/.config/kitty";
      recursive = true;
   };
   ".config/fuzzel" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fuzzel/.config/fuzzel";
      recursive = true;
   };
    ".config/hyprpanel" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hyprpanel/.config/hyprpanel";
      recursive = true;
    };
    ".config/btop" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/btop/.config/btop";
      recursive = true;
    };
    ".config/bottom" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/bottom/.config/bottom";
      recursive = true;
    };
    ".config/yazi" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/yazi/.config/yazi";
      recursive = true;
    };
    ".zshrc" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";
      recursive = true;
    };
    ".config/fontconfig/fonts.conf" = {
      source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fontconfig/.config/fontconfig";
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "emacs";
    NIXOS_OZONE_WL = "1"; # Fix Electron problems with Hyprland
  };
  
  programs.git = {
    enable = true;
    userName = "alearcy";
    userEmail = "arcidiaco.a@gmail.com";
  };
  
  fonts.fontconfig.enable = lib.mkForce false;
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
