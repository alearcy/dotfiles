{
  description = "AA NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      # Sostituisci con: hostname
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          
          # Integra Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aa = import ./home.nix;
            
            # Opzionale: passa variabili extra a home-manager
            home-manager.extraSpecialArgs = {
              dotfiles = self;  # permette di referenziare i dotfiles
            };
          }
        ];
      };
    };
  };
}
#
