m1air:
	nix build .\#darwinConfigurations.m1air.system

nixosdesktop:
	nixos-rebuild switch --flake .\#nixosdesktop
	home-manager switch --flake .#jeremy@nixos

nixosvm:
	nixos-rebuild build --flake .\#nixosvm

garbage:
	nix-collect-garbage -d