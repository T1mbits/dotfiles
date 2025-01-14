{
  getAutogenConfig,
  homeDir,
  hostDir,
  generateConfigEntries,
  lib,
  modulesDir,
  ...
}:
let
  trace = x: builtins.trace x x;

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
            trace
              (getAutogenConfig {
                inherit name;
                baseDir = homeDir;
              }).usersConfig;
        in
        {
          inherit name;
          config = usersConfig // {
            isNormalUser = true;
            home = "/home/${name}";
            extraGroups = nixpkgs.lib.mkOverride 1 (
              if builtins.elem name restrictedGroups.allowedUsers then
                usersConfig.extraGroups
              else
                builtins.filter (group: !builtins.elem group restrictedGroups.groups) usersConfig.extraGroups
            );
            shell = nixpkgs.legacyPackages.${system}.${usersConfig.shell};
          };
        }
      ) users
    );
in

generateConfigEntries {
  baseDir = hostDir;

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
        ("${hostDir}/${name}")
        {
          imports = lib.filesystem.listFilesRecursive (modulesDir + "/nixos");

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

  entryNames = (builtins.attrNames (builtins.readDir hostDir));
}
