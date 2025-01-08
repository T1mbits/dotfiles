{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.ags;
in
{
  options.hm.programs.ags = {
    enable = mkEnableOption "Enable AGS and the AGS derivation";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [
        inputs.ags.packages.${pkgs.system}.ags
        inputs.timbits-ags.packages.${pkgs.system}.default
      ];
    }
  ]);
}
