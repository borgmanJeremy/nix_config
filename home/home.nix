# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, user, config, pkgs, ... }: {
  imports = [
  ];
  nixpkgs = {
    # You can add overlays here
    overlays = [
   ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
  };

  home.packages = with pkgs; [
    tldr
    neovim
    kitty
    fish
    tmux
    #flameshot
    stow
    starship
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
