{ config, lib, ... }:
with lib;
let
  cfg = config.hm.programs.spotify-player;
in
{
  options.hm.programs.spotify-player = {
    enable = mkEnableOption "Enable spotify_player";

    clientId = mkOption {
      type = types.str;
      default = "65b708073fc0480ea92a077233ca87bd";
      description = "The Spotify app's client ID. Keep blank to use the default spotify_player ID";
    };

    defaultDevice = mkOption {
      type = types.str;
      default = cfg.deviceName;
      description = "The name of the Spotify client to automatically try and connect to";
    };

    deviceName = mkOption {
      type = types.str;
      default = "spotify_player";
      description = "Name of the Spotify client";
    };

    deviceType = mkOption {
      type = types.str;
      default = "computer";
      description = "Type of device the Spotify client should appear as";
    };
  };

  config = mkIf cfg.enable {
    programs.spotify-player = {
      enable = true;
      settings = {
        enable_notify = false;
        default_device = cfg.defaultDevice;
        client_id = cfg.clientId;

        device = {
          name = cfg.deviceName;
          device_type = cfg.deviceType;
          volume = 50;
        };
      };
    };
  };
}
