{
  dirs,
  inputs,
  pkgs,
}:
let
  lib = pkgs.lib;

  # extract and parse the autogen.nix file in the specified directory
  getAutogenConfig =
    {
      baseDir,
      name,
    }:
    let
      path = "${baseDir}/${name}/autogen.nix";
      configFile = if builtins.pathExists path then import path else { };
    in
    {
      inherit inputs name;
      system = configFile.system or "x86_64-linux";

      nixpkgs = inputs.${configFile.nixpkgs or "nixpkgs-stable"};
      home-manager = inputs.${configFile.home-manager or "home-manager-stable"};

      users = configFile.users or [ ];
      restrictedGroups = {
        allowedUsers = configFile.restrictedGroups.allowedUsers or [ ];
        groups = configFile.restrictedGroups.groups or [ ];
      };

      usersConfig = configFile.usersConfig or { };
    };

  # template for creating nixosConfiguration or homeConfiguration entries in a flake
  generateConfigEntries =
    {
      baseDir,
      configTemplate,
      entryNames,
    }:
    builtins.listToAttrs (
      map
        (config: {
          inherit (config) name value;
        })
        (
          map (name: {
            inherit name;
            value = (
              configTemplate (getAutogenConfig {
                inherit baseDir name;
              })
            );
          }) entryNames
        )
    );

  # Create a NixOS user in the NixOS system using the autogen.nix inside of home configurations
  generateNixosUsers =
    {
      nixpkgs,
      restrictedGroups,
      system,
      users,
    }:
    builtins.foldl' (acc: user: acc // { ${user.name} = user.config; }) { } (
      map (
        name:
        let
          usersConfig =
            (getAutogenConfig {
              inherit name;
              baseDir = dirs.homes;
            }).usersConfig;
        in
        {
          inherit name;
          config = usersConfig // {
            isNormalUser = true;
            home = "/home/${name}";
            extraGroups = lib.mkOverride 0 (
              if builtins.elem name restrictedGroups.allowedUsers then
                usersConfig.extraGroups
              else
                builtins.filter (group: !builtins.elem group restrictedGroups.groups) usersConfig.extraGroups
            );
            shell =
              lib.mkIf (lib.isString usersConfig.shell)
                nixpkgs.legacyPackages.${system}.${usersConfig.shell};
          };
        }
      ) users
    );
in
{
  nixosConfigurations = generateConfigEntries {
    baseDir = dirs.hosts;

    configTemplate =
      {
        inputs,
        name,
        nixpkgs,
        restrictedGroups,
        system,
        users,
        ...
      }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs system; };
        modules = [
          "${dirs.hosts}/${name}"
          {
            imports = lib.flatten [
              (import ./derivations.nix { inherit dirs; }).nixosDrvModules
              (lib.filesystem.listFilesRecursive (dirs.modules + "/nixos"))
            ];

            users.users = (
              generateNixosUsers {
                inherit
                  nixpkgs
                  restrictedGroups
                  system
                  users
                  ;
              }
            );
          }
        ];
      };

    entryNames = (builtins.attrNames (builtins.readDir dirs.hosts));
  };

  homeConfigurations = generateConfigEntries {
    baseDir = dirs.homes;
    configTemplate =
      {
        inputs,
        home-manager,
        name,
        nixpkgs,
        system,
        ...
      }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        extraSpecialArgs = { inherit inputs system; };
        modules = [
          (dirs.homes + "/${name}")
          {
            imports = lib.flatten [
              # (import ./derivations.nix { inherit dirs; }).homeDrvModules
              (lib.filesystem.listFilesRecursive (dirs.modules + "/home"))
            ];

            home = {
              username = name;
              homeDirectory = "/home/${name}";
            };
          }
        ];
      };

    entryNames = (builtins.attrNames (builtins.readDir dirs.homes));
  };
}
