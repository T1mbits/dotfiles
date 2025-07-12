{ config, lib, ... }:
with lib;
let
  cfg = config.custom.services.zerotier;
in
{
  options.custom.services.zerotier = {
    enable = mkEnableOption "Enable zerotierone";
    joinNetworks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "ZeroTier network IDs to join on startup";
    };
  };

  config = mkIf cfg.enable {
    services.zerotierone = {
      enable = true;
      joinNetworks = cfg.joinNetworks;
    };
  };
}
