{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.oskars-dotfiles.overlays.spotx ];

  home.packages = [
    pkgs.spotify
  ];
}
