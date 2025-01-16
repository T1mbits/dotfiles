{ inputs, pkgs }:
let
  dirs = {
    derivations = ../derivations;
    homes = ../home;
    hosts = ../host;
    modules = ../modules;
  };
in
{
  autogen = import ./autogen.nix { inherit dirs inputs pkgs; };
}
