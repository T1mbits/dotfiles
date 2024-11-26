{ pkgs, oskars-dotfiles, ... }:
{
  pkgs.overlays = [ oskars-dotfiles.overlays.spotx ];

  home.packages = [
    pkgs.spotify
  ];
}
