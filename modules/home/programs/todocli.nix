{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.todocli;
in
{
  options.hm.programs.todocli = {
    enable = mkEnableOption "Enable todocli";
  };

  config = mkIf cfg.enable { home.packages = [ (import ../../../derivations/todocli pkgs) ]; };
}
