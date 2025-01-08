{ config, lib, ... }:
with lib;
let
  cfg = config.base.ssh;
in
{
  options.base.ssh = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SSH system configuration";
    };

    additionalPorts = mkOption {
      type = types.listOf types.int;
      default = [ ];
      description = "Additional ports to use as SSH ports";
    };
  };

  config = mkIf cfg.enable {
    programs.ssh.startAgent = true;

    services.openssh = {
      enable = true;
      ports = [ 22 ] ++ cfg.additionalPorts;
    };
  };
}
