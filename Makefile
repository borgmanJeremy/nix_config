m1air:
	nix build .\#darwinConfigurations.jeremys-macbook-air.system
	./result/sw/bin/darwin-rebuild switch --flake .#jeremys-macbook-air 
	home-manager switch --flake .#jeremy@jeremys-macbook-air --impure

nixosdesktop:
	sudo nixos-rebuild switch --flake .\#nixosdesktop
	home-manager switch --flake .#jeremy@nixos --impure

nixosvm:
	nixos-rebuild build --flake .\#nixosvm

garbage:
	nix-collect-garbage -d
