{ config, lib, ... }:
with lib;
let
  cfg = config.custom.services.tailscale;
in
{
  options.custom.services.tailscale = {
    enable = mkEnableOption "Enable tailscale client";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
    };
  };
}
