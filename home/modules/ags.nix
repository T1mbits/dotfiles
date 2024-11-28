{ inputs, pkgs, ... }:
let
  ags = inputs.ags.packages.${pkgs.system};
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    configDir = ../../ags;

    extraPackages = [
      ags.auth
      ags.apps
      ags.battery
      ags.cava
      ags.greet
      ags.hyprland
      ags.mpris
      ags.network
      ags.notifd
      ags.powerprofiles
      ags.tray
      ags.wireplumber
    ];
  };
}
