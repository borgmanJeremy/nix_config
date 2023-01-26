m1air:
	nix build .\#darwinConfigurations.Jeremys-MacBook-Air.system
	./result/sw/bin/darwin-rebuild switch --flake .
	home-manager switch --flake .#jeremy@Jeremys-MacBook-Air

nixosdesktop:
	nixos-rebuild switch --flake .\#nixosdesktop
	home-manager switch --flake .#jeremy@nixos

nixosvm:
	nixos-rebuild build --flake .\#nixosvm

garbage:
	nix-collect-garbage -d
