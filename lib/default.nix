{ inputs }:
let
  lib = rec {
    hostDir = ../host;
    homeDir = ../home;

    getAutogenConfig =
      {
        baseDir,
        name,
      }:
      let
        path = "${baseDir}/${name}/autogen-config.nix";
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
# {
#   generateHomes =
#     {
#       homeManagerMap,
#       nixpkgsMap,
#       inputs,
#     }:
#     let
#       homes = map (
#         name:
#         let
#           config = getModuleOrEmpty (homeDir + "/${name}/autogen-config.nix");
#         in
#         {
#           inherit name;
#           config = homeManagerMap.${config.home-manager or "home-manager"}.lib.homeManagerConfiguration {
#             pkgs = import nixpkgsMap.${config.nixpkgs or "nixpkgs"} {
#               system = config.system or "x86_64-linux";
#               config.allowUnfree = true;
#             };
#             extraSpecialArgs = { inherit inputs; };
#             modules = [
#               (homeDir + "/${name}")
#               {
#                 home = {
#                   username = name;
#                   homeDirectory = "/home/${name}";
#                 };
#               }
#             ];
#           };
#         }
#       ) (builtins.filter (home: home != "modules") (builtins.attrNames (builtins.readDir homeDir)));
#     in
#     builtins.listToAttrs (
#       map (home: {
#         name = home.name;
#         value = home.config;
#       }) homes
#     );
# }
