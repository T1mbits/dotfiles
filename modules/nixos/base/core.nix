{ config, lib, ... }:
with lib;
let
  cfg = config.base.core;
in
{
  options.base.core = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable core configurations that should be enabled on most machines";
    };

    systemdBoot = mkOption {
      type = types.bool;
      default = true;
      description = "Use systemd-boot as the system bootloader";
    };

    networkManager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable networkmanager";
      };

      connectivity = mkOption {
        type = types.bool;
        default = true;
        description = "Enable networkmanager's connectivity check feature";
      };
    };
  };

  config = mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    services = {
      upower.enable = true;
    };

    boot.loader = mkIf cfg.systemdBoot {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.networkmanager = {
      enable = mkIf cfg.networkManager.enable true;
      settings = mkIf cfg.networkManager.connectivity {
        connectivity = {
          enabled = true;
          uri = "http://nmcheck.gnome.org/check_network_status.txt";
          interval = 300;
          timeout = 20;
          response = "NetworkManager is online";
        };
      };
    };
  };
}
