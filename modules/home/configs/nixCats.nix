{
  config,
  inputs,
  lib,
  system,
  ...
}:
with lib;
let
  cfg = config.hm.configs.nixCats;
  nixCats = import ../../../derivations/nixCats { inherit inputs; };
in
{
  options.hm.configs.nixCats = {
    enable = mkEnableOption "Enable nixCats as NeoVim configuration";
  };
  config = mkIf cfg.enable {
    home.packages = [ nixCats.packages.${system}.nvim ];
  };
}
