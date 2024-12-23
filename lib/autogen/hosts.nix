{
  getAutogenConfig,
  homeDir,
  hostDir,
  generateConfigEntries,
  ...
}:
let
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

  entryNames = (
    builtins.filter (host: host != "default.nix") (builtins.attrNames (builtins.readDir hostDir))
  );
}
