{
  homeDir,
  generateConfigEntries,
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
          home = {
            username = name;
            homeDirectory = "/home/${name}";
          };
        }
      ];
    };
  entryNames = (
    builtins.filter (home: home != "modules") (builtins.attrNames (builtins.readDir homeDir))
  );
}
