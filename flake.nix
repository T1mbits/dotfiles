{
  description = "Timbits' dotfiles";

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      home-manager-unstable,
      ...
    }@inputs:
    let
      nixpkgsMap = { inherit nixpkgs nixpkgs-unstable; };
      homeManagerMap = { inherit home-manager home-manager-unstable; };

      lib = import ./lib;
    in
    {
      nixosConfigurations = lib.generateHosts { inherit nixpkgsMap inputs; };
      homeConfigurations = lib.generateHomes { inherit homeManagerMap nixpkgsMap inputs; };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # TODO revert to unstable for astal + ags once m4 bug is patched in unstable
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    timbits-nixvim = {
      url = "path:./pkgs/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
}
