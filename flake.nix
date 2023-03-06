{
  description = "Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    customFlameshot = {
      url = "github:borgmanJeremy/flameshot/removeImgur";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }@inputs: 
    let 
      user = "jeremy";
    in
    {
      overlays = import ./overlays { inherit inputs; };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixosvm = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; }; 
          modules = [ 
            ./hosts/qemu_vm/configuration.nix 
          ];
        };

        nixosdesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; }; 
          modules = [ 
            ./hosts/desktop/configuration.nix
           ];
        };
      };

      darwinConfigurations."Jeremys-MacBook-Air" = darwin.lib.darwinSystem {
            system = "aarch64-darwin"; 
            modules = [./hosts/darwin/default.nix];
      };

      homeConfigurations = {
        "jeremy@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; 
          extraSpecialArgs = {
            inherit inputs user;
                  pkgs-unstable   = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; };
          };
          modules = [ ./home/home.nix ];
        };

        "jeremy@Jeremys-MacBook-Air" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; 
          extraSpecialArgs = {
            inherit inputs user;
                  pkgs-unstable = import nixpkgs-unstable { system = "aarch64-darwin"; config.allowUnfree = true; };
          };
          modules = [ ./home/home.nix ];
        };


      };
    };
}
