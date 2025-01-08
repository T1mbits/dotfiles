{
  generateConfigEntries,
  homeDir,
  lib,
  modulesDir,
  ...
}:
generateConfigEntries {
  baseDir = homeDir;
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

      extraSpecialArgs = { inherit inputs; };
      modules = [
        (homeDir + "/${name}")
        {
          imports = lib.filesystem.listFilesRecursive (modulesDir + "/home");

          home = {
            username = name;
            homeDirectory = "/home/${name}";
          };
        }
      ];
    };
  entryNames = (builtins.attrNames (builtins.readDir homeDir));
}
