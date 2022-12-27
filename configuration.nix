# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.gvfs.enable = true;

  services.flatpak.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Enable gnome extensions
  nixpkgs.config.firefox.enableGnomeExtensions = true;

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeremy = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "jeremy";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      firefox
      libreoffice
      gnupg
      lm_sensors
      calibre
      openssl
      vim
      tldr
      neovim
      starship
      fish
      pinentry-gnome
      tmux
      htop
      tailscale
      kitty
      flameshot
      stow
      gitFull
      barrier
      prusa-slicer
      vscode
      docker-compose
      direnv
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
