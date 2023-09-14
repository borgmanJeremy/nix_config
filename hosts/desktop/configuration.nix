# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  user,
  ...
}: {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];

  nixpkgs = {
    overlays = [(import ../../overlays/default.nix)];

    # Configure your nixpkgs instance
    config = {allowUnfree = true;};
  };

  services.rpcbind.enable = true; # needed for NFS

  ## Remote Mounts
  systemd.mounts = [
    {
      type = "nfs";
      mountConfig = {Options = "noatime";};
      what = "192.168.1.77:/data/arr";
      where = "/mnt/falcon/data/arr";
    }
    {
      type = "nfs";
      mountConfig = {Options = "noatime";};
      what = "192.168.1.77:/data/media/pictures";
      where = "/mnt/falcon/data/media/pictures";
    }
    {
      type = "nfs";
      mountConfig = {Options = "noatime";};
      what = "192.168.1.77:/data/media/video";
      where = "/mnt/falcon/data/media/video";
    }
  ];

  systemd.automounts = [
    {
      wantedBy = ["multi-user.target"];
      automountConfig = {TimeoutIdleSec = "600";};
      where = "/mnt/falcon/data/media/pictures";
    }
    {
      wantedBy = ["multi-user.target"];
      automountConfig = {TimeoutIdleSec = "600";};
      where = "/mnt/falcon/data/arr";
    }
    {
      wantedBy = ["multi-user.target"];
      automountConfig = {TimeoutIdleSec = "600";};
      where = "/mnt/falcon/data/media/video";
    }
  ];

  # boot.zfs.extraPools = ["external_backup"];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath =
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.

  my.gui.enable = true;
  my.gui.usePlasma = true;

  my.commonDesktopOptions.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # zfs
  services.zfs.autoScrub.enable = true;

  # Required to mount nfs via cli
  services.nfs.server.enable = true;

  services.syncthing = {
    enable = true;
    user = "jeremy";
    dataDir = "/home/jeremy/Sync";
    configDir = "/home/jeremy/.config/syncthing";
  };

  # Set up yubikey
  services.pcscd.enable = true;
  programs.ssh.startAgent = false;
  services.udev.packages = [pkgs.yubikey-personalization];
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };
  programs.fish.enable = true;

  networking.hostId = "f4485321";
  boot.supportedFilesystems = ["zfs"];

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  services.xserver.videoDrivers = ["amdgpu"];

  services.sunshine.enable = true;
  programs.steam.enable = true; # optional

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeremy = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "jeremy";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "scanner" "lp"];
    packages = with pkgs; [
      barrier
      blender
      calibre
      digikam
      pkgs-unstable.distrobox
      file
      firefox
      flatpak
      freecad
      gnupg
      handbrake
      home-manager
      joplin-desktop
      k3b
      kdenlive
      libreoffice
      libvirt
      lm_sensors
      pkgs-unstable.makemkv
      nextcloud-client
      obs-studio
      openssl
      pinentry-curses
      podman-compose
      protonvpn-gui
      prusa-slicer
      python311
      rawtherapee
      sanoid
      signal-desktop
      steam
      tailscale
      virt-manager
      virt-viewer

      xorg.xhost

      yubikey-manager
      yubikey-manager-qt
      yubikey-touch-detector
      yuzu-ea
    ];
  };

  environment.systemPackages = with pkgs; [nfs-utils vim kde-rounded-corners];

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
