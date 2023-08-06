{
  description = "Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    customFlameshot = {
      url = "github:borgmanJeremy/flameshot";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    darwin,
    home-manager,
    ...
  } @ inputs: let
    user = "jeremy";
    homedir = "/home/jeremy/";
  in {
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixosvm = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/qemu_vm/configuration.nix
        ];
      };

      nixosdesktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };

        modules = [
          ./hosts/desktop/configuration.nix
        ];
      };
    };

    darwinConfigurations."jeremys-macbook-air" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [./hosts/darwin/default.nix];
    };

    homeConfigurations = {
      "jeremy@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs user homedir;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./home/home.nix
        ];
      };

      "jeremy@jeremys-macbook-air" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          homedir = "/Users/jeremy";
          inherit inputs user;
          pkgs-unstable = import nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        };
        modules = [./home/home.nix];
      };
    };
  };
}
