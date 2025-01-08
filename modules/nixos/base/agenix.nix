{
  config,
  inputs,
  lib,
  system,
  ...
}:
with lib;
let
  cfg = config.base.agenix;
in
{
  options.base.agenix = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable agenix";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages.${system}.default
    ];
  };
}
