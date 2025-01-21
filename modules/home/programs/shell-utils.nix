{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.shell-utils;
in
{
  options.hm.programs.shell-utils = {
    enable = mkEnableOption "Enable shell utilities";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      eza
      fd
    ];

    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "fd --type file -HE .git";
        fileWidgetCommand = "fd --type file -HE .git";
      };

      ranger = {
        enable = true;
        settings = {
          preview_images = true;
          preview_images_method = "kitty";
        };
      };

      zoxide.enable = true;
    };
  };
}
