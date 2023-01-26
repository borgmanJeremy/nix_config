{
  description = "Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs: 
    let 
      user = "jeremy";
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixosvm = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [ 
            ./hosts/qemu_vm/configuration.nix 
          ];
        };

        nixosdesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [ 
            ./hosts/desktop/configuration.nix
           ];
        };
      };

      darwinConfigurations."Jeremys-MacBook-Air" = darwin.lib.darwinSystem {
            system = "aarch64-darwin"; 
            modules = [./hosts/m1air/default.nix];
      };

      homeConfigurations = {
        "jeremy@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; 
          extraSpecialArgs = { inherit inputs; inherit user;}; 
          modules = [ ./home/home.nix ];
        };

        "jeremy@Jeremys-MacBook-Air" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; 
          extraSpecialArgs = { inherit inputs; inherit user;}; 
          modules = [ ./home/home.nix ];
        };


      };
    };
}
