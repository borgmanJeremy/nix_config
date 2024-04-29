{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.commonDesktopOptions;
in {
  options.my.commonDesktopOptions = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables common desktop options";
    };
  };

  config = mkIf cfg.enable {
    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.utf8";

    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };

    services.printing.enable = true;
    services.fwupd.enable = true;

    networking.networkmanager.enable = true;

    services.flatpak.enable = true;
    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = false;

    services.tailscale.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    virtualisation.libvirtd.enable = true;
  };
}
