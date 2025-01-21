{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.nixbits;
in
{
  options.hm.programs.nixbits = {
    enable = mkEnableOption "Enable nixbits script";
  };

  config = mkIf cfg.enable {
    home.packages = [ (import ../../../derivations/nixbits pkgs) ];
  };
}
