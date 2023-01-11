m1air:
	nix build .\#darwinConfigurations.m1air.system

nixosdesktop:
	nixos-rebuild build --flake .\#nixosdesktop

nixosvm:
	nixos-rebuild build --flake .\#nixosvm

