{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.services.swww;
in
{
  options.hm.services.swww = {
    enable = mkEnableOption "Enable swww";

    wallpaper = mkOption {
      type = types.path;
      description = "Path to wallpaper to use for the system";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.swww ];

    systemd.user.services.swww-daemon = {
      Unit.Description = "swww-daemon";
      Install.WantedBy = [ "default.target" ];
      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
      };
    };

    /* home.activation = {
      changeSwwwWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.swww}/bin/swww img ${cfg.wallpaper} --transition-type grow --transition-fps 60 --transition-duration 5
      '';
    }; */
  };
}
