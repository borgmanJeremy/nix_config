# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, user, config, pkgs, pkgs-unstable, ... }: {
  imports = [
  ];
  nixpkgs = {
    # You can add overlays here
    overlays = [
   ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # allowUnsupportedSystem = true;
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
    fish
    tmux
    starship
    htop
    gnumake
    ripgrep
    direnv

    pkgs-unstable.flameshot
  ];

  programs.git = {
    enable = true;
    userName = "Jeremy Borgman";
    userEmail = "borgman.jeremy@pm.me";
  };

  programs.kitty ={
    enable = true;
    font.size = 16;
    font.name = "DejuVu Sans Mono";
    theme = "Afterglow";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
