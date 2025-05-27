{
  description = "Timbits' dotfiles";

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = import ./lib {
        inherit self inputs;
        pkgs = nixpkgs;
      };
    in
    {
      nixosConfigurations = lib.autogen.nixosConfigurations;
      homeConfigurations = lib.autogen.homeConfigurations;
    };

  inputs = {
    # nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # External frameworks, libraries, programs, etc.
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Derivations
    timbits-ags = {
      url = "path:./derivations/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
