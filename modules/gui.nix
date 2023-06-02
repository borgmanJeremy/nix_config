{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.my.gui;
in
{
  options.my.gui = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable a GUI";
    };

    useGnome = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Gnome";
    };
    usePlasma = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Plasma";
    };
  };

  config = mkMerge
  [ 
    (mkIf cfg.enable {
      services.xserver.enable = true;

      sound.enable = true;
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    })
     
    (mkIf cfg.useGnome {
      services.gvfs.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      nixpkgs.config.firefox.enableGnomeExtensions = true;
    })

    (mkIf cfg.usePlasma {
      services.xserver.displayManager.sddm.enable = true;
      services.xserver.desktopManager.plasma5.enable = true;
    })
  ];
}