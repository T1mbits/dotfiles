{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.spotify;
in
{
  options.hm.programs.spotify = {
    enable = mkEnableOption "Enable official Spotify client";
    spotx = mkEnableOption "Apply SpotX-Bash patch";

    customDesktopFile = mkOption {
      type = types.bool;
      default = true;
      description = "Override default spotify.desktop with a patched one";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.spotify ];

    nixpkgs.overlays = mkIf cfg.spotx [ inputs.oskars-dotfiles.overlays.spotx ];

    xdg.desktopEntries.spotify = mkIf cfg.customDesktopFile {
      name = "Spotify";
      exec = "sh -c \"spotify --ozone-platform=wayland %U > /dev/null 2>&1\"";
      icon = "spotify-client";
      type = "Application";
      genericName = "Music Player";
      mimeType = [ "x-scheme-handler/spotify" ];
      categories = [
        "Audio"
        "Music"
        "Player"
        "AudioVideo"
      ];
      settings = {
        Keywords = "discord;vencord;electron;chat";
        StartupWMClass = "spotify";
      };
    };
  };
}
