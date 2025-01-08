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

    networkManager = mkOption {
      type = types.bool;
      default = true;
      description = "Enable networkmanager";
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

    networking.networkmanager.enable = mkIf cfg.networkManager true;
  };
}
