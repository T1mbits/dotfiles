{
  description = "Timbits' dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    oskars-dotfiles = {
      url = "github:oskardotglobal/.dotfiles/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      home-manager-unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        framework = nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./host/framework/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        Timbits = home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./users/Timbits.nix ];
        };
      };
    };
}
