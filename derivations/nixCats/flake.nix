{
  description = "Simple test flake for nixCats configuration tweaking";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      nixCatsConfig = import ./. { inherit inputs; };
    in
    {
      packages."x86_64-linux".default = nixCatsConfig.packages."x86_64-linux".nvim;
    };
}
