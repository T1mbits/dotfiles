{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.configs.stylix;
  themesDir = ../../../themes;
  themeDir = "${themesDir}/${cfg.theme}";
in
{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  options.hm.configs.stylix = {
    enable = mkEnableOption "Enable Stylix";

    theme = mkOption {
      type = types.str;
      default = null;
      description = "Path to theme directory (./themes directory as root)";
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;

      image = themeDir + "/wallpaper.jpg";
      base16Scheme = themeDir + "/colours.yaml";

      opacity.terminal = 0.9;

      iconTheme = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus";
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
      };

      targets = {
        hyprland.hyprpaper.enable = false;
        vscode.enable = false;
      };
    };

    hm.services.swww.wallpaper = mkIf config.hm.services.swww.enable config.stylix.image;
  };
}
