# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];

  nixpkgs = {
    overlays = [
   ];

    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  networking.hostName = "nixos"; # Define your hostname.

  my.gui.enable = true;
  my.gui.useGnome = true;
  my.commonDesktopOptions.enable = true;
  
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Set up yubikey
  services.pcscd.enable=true;
  programs.ssh.startAgent = false;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  programs.gnupg.agent.pinentryFlavor = "gnome3";
    environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  ''; 
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.hostId = "f4485321";
  boot.supportedFilesystems = ["zfs"];

  services.xserver.videoDrivers = ["amdgpu"];
  programs.steam.enable = true; # optional
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeremy = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "jeremy";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd"];
    packages = with pkgs; [
      home-manager
      steam
      firefox
      libvirt
      libreoffice
      gnupg
      lm_sensors
      calibre
      openssl
      pinentry-gnome
      tailscale
      barrier
      prusa-slicer
      vscode
      docker-compose
      freecad
      flatpak
      handbrake
      vlc
      virt-viewer
      virt-manager
      nextcloud-client
      sanoid

      gnomeExtensions.dash-to-dock
      gnomeExtensions.appindicator
      gnomeExtensions.pop-shell
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

