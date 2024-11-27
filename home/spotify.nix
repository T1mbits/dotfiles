{ pkgs, oskars-dotfiles, ... }:
{
  nixpkgs.overlays = [ oskars-dotfiles.overlays.spotx ];

  home.packages = [
    pkgs.spotify
  ];
}
