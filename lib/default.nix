{ inputs }:
let
  lib = rec {
    hostDir = ../host;
    homeDir = ../home;
    modulesDir = ../modules;

    lib = (import inputs.nixpkgs { system = "x86_64-linux"; }).lib;

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
  };
in
{
  autogen = {
    hosts = import ./autogen/hosts.nix lib;
    homes = import ./autogen/homes.nix lib;
  };
}
