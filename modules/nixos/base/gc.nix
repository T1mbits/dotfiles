{ config, lib, ... }:
with lib;
let
  cfg = config.base.gc;
in
{
  options.base.gc = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable weekly automatic garbage collection";
    };
  };

  config = mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
