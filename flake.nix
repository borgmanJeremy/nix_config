{
  description = "Nix Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs: {
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

    darwinConfigurations."m1air" = darwin.lib.darwinSystem {
          system = "aarch64-darwin"; 
          modules = [./hosts/m1air/default.nix];
    };

  };
}
