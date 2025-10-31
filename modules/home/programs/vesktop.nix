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
    ignoreStylix = mkEnableOption "Use default Discord theme instead of Stylix's";
    enablePlugins = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Vencord plugins to enable automatically";
    };

    pluginsWithSettings = mkOption {
      type = types.attrsOf types.attrs;
      default = { };
      description = "Declare vencord plugins with options";
    };

    customDesktopFile = mkOption {
      type = types.bool;
      default = true;
      description = "Override default vesktop.desktop with a patched one";
    };
  };

  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;

      vencord.settings.plugins =
        let
          enabledPlugins = builtins.listToAttrs (
            map (name: {
              inherit name;
              value = {
                enabled = true;
              };
            }) cfg.enablePlugins
          );
        in
        attrsets.recursiveUpdate enabledPlugins cfg.pluginsWithSettings;
    };

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
