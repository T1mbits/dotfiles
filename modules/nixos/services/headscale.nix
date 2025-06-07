{ config, lib, ... }:
with lib;
let
  cfg = config.custom.services.headscale;
in
{
  options.custom.services.headscale = {
    enable = mkEnableOption "Make the device a headscale server";
  };

  config = mkIf cfg.enable {
    services.headscale = {
      enable = true;

      address = "127.0.0.1";
      port = 443;

      settings = {
        server_url = "";
        dns.magic_dns = false;
      };
    };
  };
}
