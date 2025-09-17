# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hyprland, swww, hyprpanel, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Abilita flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot = {
    plymouth = {
      enable = true;
      theme = "spinner"; # tema base sempre disponibile
    };
    
    # Assicurati che l'initrd sia configurato correttamente
    initrd = {
      systemd.enable = true; # raccomandato con Plymouth
      verbose = false; # nasconde i messaggi di boot
    };
    
    # Parametri kernel per Plymouth
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
    ];
    
    # Se usi LUKS, aggiungi questo
    # initrd.luks.devices."root".allowDiscards = true;
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixaa"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.displayManager.lightdm.enable = false;
  #services.displayManager.sessionPackages = [hyprland.packages.${pkgs.system}.hyprland];
  programs.dconf.enable = true;
  
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aa = {
    isNormalUser = true;
    description = "aa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # This packages list is only for pkg that not require (or I don't need to) additional options, otherwise use programs.pks = syntax.
  # To check if a package has additional options look at https://nixos.org/manual/nixos/stable/options
  environment.systemPackages = with pkgs; [
    wget
    curl
    bat
    git
    starship
    nil # nix lsp
    python314
    fzf
    eza
    gopls
    rust-analyzer
    firefox
    emacs
    neovim
    ripgrep
    yazi
    lazygit
    tree
    zsh
    zoxide
    lazydocker
    helix
    hyprlock
    btop
    kitty
    fuzzel
    fastfetch
    swww.packages.${pkgs.system}.swww
    google-chrome
    hyprpanel.packages.${pkgs.system}.hyprpanel
    glib #gsettings
    # Pacchetti necessari per gli schemi gsettings
    gsettings-desktop-schemas  # Schemi base di GNOME/GTK
    gtk3                       # Librerie GTK3
    gtk4                       # Librerie GTK4 (se usi app che le richiedono)
  ];

  environment.variables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
  };
  
  # Hyprland installation and configuration from unstable version from flake.nix (the oldest hypr pkg is in the nixpkgs repo, the latest is in the flake input) 
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
