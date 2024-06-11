{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; let
  cfg = config.my.gui;
in {
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
    useBudgie = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Budgie";
    };
    useSway = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use Sway";
    };
  };

  config = mkMerge [
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

    (mkIf cfg.useBudgie {
      services.xserver.enable = true;
      services.xserver.desktopManager.budgie.enable = true;
      services.xserver.displayManager.lightdm.enable = true;
    })

    (mkIf cfg.useSway {
      services.xserver.displayManager.gdm.enable = true;
      programs.sway.enable = true;
    })

    (mkIf cfg.usePlasma {
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;
      # services.xserver.displayManager.autoLogin.enable = true;
      # services.xserver.displayManager.autoLogin.user = "${user}";
    })
  ];
}
