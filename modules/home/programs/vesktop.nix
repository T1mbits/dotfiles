{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.vesktop;
in
{
  options.hm.programs.vesktop = {
    enable = mkEnableOption "Enable Vesktop";

    customDesktopFile = mkOption {
      type = types.bool;
      default = true;
      description = "Override default vesktop.desktop with a patched one";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.vesktop ];

    xdg.desktopEntries.vesktop = mkIf cfg.customDesktopFile {
      name = "Vesktop";
      exec = "sh -c \"vesktop --ozone-platform=wayland %U > /dev/null 2>&1\"";
      comment = "Furry Discord because wayland. Discord never krisp :(";
      icon = "vesktop";
      genericName = "Internet Messenger";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      settings = {
        Keywords = "discord;vencord;electron;chat";
        StartupWMClass = "Vesktop";
      };
    };
  };
}
