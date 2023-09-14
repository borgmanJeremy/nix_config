{
  config,
  lib,
  pkgs-unstable,
  ...
}:
with lib; let
  cfg = config.services.sunshine;
in {
  options = {
    services.sunshine = {
      enable = mkEnableOption (mdDoc "Sunshine");
    };
  };

  config = mkIf config.services.sunshine.enable {
    environment.systemPackages = [
      pkgs-unstable.sunshine
    ];

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs-unstable.sunshine}/bin/sunshine";
    };

    systemd.user.services.sunshine = {
      description = "sunshine";
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${config.security.wrapperDir}/sunshine";
        Restart = "always";
      };
    };
  };
}
