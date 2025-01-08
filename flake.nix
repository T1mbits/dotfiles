{
  description = "Timbits' dotfiles";

  outputs =
    { ... }@inputs:
    let
      lib = import ./lib { inherit inputs; };
    in
    {
      nixosConfigurations = lib.autogen.hosts;
      homeConfigurations = lib.autogen.homes;
    };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    timbits-ags = {
      url = "path:./derivations/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    timbits-nixvim = {
      url = "path:./derivations/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
