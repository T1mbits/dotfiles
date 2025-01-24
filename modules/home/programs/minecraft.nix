{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.prism-launcher;
in
{
  options.hm.programs.prism-launcher = {
    enable = mkEnableOption "Enable Prism Launcher";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.prismlauncher
    ];
  };
}
