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
    starship
    htop
    gnumake
    ripgrep
    direnv

    pkgs-unstable.flameshot
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
        # Commands to run in interactive sessions can go here
        set -x GPG_TTY (tty)
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent

        starship init fish | source
        direnv hook fish | source
    '';
  };

  programs.git = {
    enable = true;
    userName = "Jeremy Borgman";
    userEmail = "borgman.jeremy@pm.me";
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      setw -g mode-keys vi
      unbind -T copy-mode-vi Space; #Default for begin-selection
      unbind -T copy-mode-vi Enter; #Default for copy-selection
      
      bind -T copy-mode-vi v
      bind -T copy-mode-vi y

      set -g mouse on

      set -g history-limit 10000

      # Split panes with | and -
      unbind '"'
      unbind %
      bind | split-window -h
      bind - split-window -v

      #### COLOUR (Solarized dark)
      
      # default statusbar colors
      set-option -g status-style fg=yellow,bg=black #yellow and base02
      
      # default window title colors
      set-window-option -g window-status-style fg=brightblue,bg=default #base0 and default
      #set-window-option -g window-status-style dim
      
      # active window title colors
      set-window-option -g window-status-current-style fg=brightred,bg=default #orange and default
      #set-window-option -g window-status-current-style bright
      
      # pane border
      set-option -g pane-border-style fg=black #base02
      set-option -g pane-active-border-style fg=brightgreen #base01
      
      # message text
      set-option -g message-style fg=brightred,bg=black #orange and base01
      
      # pane number display
      set-option -g display-panes-active-colour brightred #orange
      set-option -g display-panes-colour blue #blue
      
      # clock
      set-window-option -g clock-mode-colour green #green
      
      # bell
      set-window-option -g window-status-bell-style fg=black,bg=red #base02, red
    '';
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
