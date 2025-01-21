{ config, lib, ... }:
with lib;
let
  cfg = config.hm.programs.tmux;
in
{
  options.hm.programs.tmux = {
    enable = mkEnableOption "Enable tmux and its config";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };
  };
}
