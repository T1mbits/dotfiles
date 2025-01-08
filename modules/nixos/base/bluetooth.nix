{ config, lib, ... }:
with lib;
let
  cfg = config.base.bluetooth;
in
{
  options.base.bluetooth = {
    enable = mkEnableOption "Enable bluetooth";

    blueman = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the blueman bluetooth manager";
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = mkIf cfg.blueman true;
  };
}
