m1air:
	nix build .\#darwinConfigurations.Jeremys-MacBook-Air.system
	./result/sw/bin/darwin-rebuild switch --flake .
	home-manager switch --flake .#jeremy@Jeremys-MacBook-Air --impure

nixosdesktop:
	sudo nixos-rebuild switch --flake .\#nixosdesktop
	home-manager switch --flake .#jeremy@nixos --impure

nixosvm:
	nixos-rebuild build --flake .\#nixosvm

garbage:
	nix-collect-garbage -d
