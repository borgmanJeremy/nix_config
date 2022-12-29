# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "jeremy";
    homeDirectory = "/home/jeremy";
  };

  home.packages = with pkgs; [ 
      firefox 
      flameshot
      libreoffice
      calibre
      nextcloud-client
      vlc
      handbrake

      vscode 
      htop

      kitty
      starship
      tmux
      direnv
      tldr
      neovim
      git
      gnupg
      pinentry-gnome

      gnomeExtensions.dash-to-dock
      gnomeExtensions.appindicator
      gnomeExtensions.pop-shell
    ];

  programs.home-manager.enable = true;
  programs.git= {
    enable = true;
    userEmail = "borgman.jeremy@pm.me";
    userName = "Jeremy Borgman";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "nvim";
      };
    };
  };

  programs.kitty = {
    enable = true;
    font.size = 14;
    font.name = "inconsolata";
    theme = "moonlight";
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    extraConfig = ''
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
      set -g mouse on
      bind r source-file ~/.config/tmux/tmux.conf
      '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
