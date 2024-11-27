{ inputs, pkgs, ... }:
let
  ags = inputs.ags.${pkgs.system};
in
{
  programs.ags = {
    enable = true;

    configDir = ../ags;

    extraPackages = with pkgs; [
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
