let
  getModuleOrEmpty = modulePath: if builtins.pathExists modulePath then import modulePath else { };
in
{
  generateHosts =
    {
      nixpkgsMap,
      inputs,
    }:
    let
      hostsDir = ../host;

      allHosts = map (
        name:
        let
          config = getModuleOrEmpty (hostsDir + "/${name}/autogen-config.nix");

          system = config.system or "x86_64-linux";
        in
        {
          inherit name;
          config = nixpkgsMap.${config.nixpkgs or "nixpkgs"}.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs system; };
            modules = [
              (hostsDir + "/${name}")
            ];
          };
        }
      ) (builtins.attrNames (builtins.readDir hostsDir));
      hosts = builtins.filter (host: host.name != "default.nix") allHosts;
    in
    builtins.listToAttrs (
      map (host: {
        name = host.name;
        value = host.config;
      }) hosts
    );

  generateHomes =
    {
      homeManagerMap,
      nixpkgsMap,
      inputs,
    }:
    let
      homeDir = ../home;

      allHomes = map (
        name:
        let
          config = getModuleOrEmpty (homeDir + "/${name}/autogen-config.nix");
        in
        {
          inherit name;
          config = homeManagerMap.${config.home-manager or "home-manager"}.lib.homeManagerConfiguration {
            pkgs = import nixpkgsMap.${config.nixpkgs or "nixpkgs"} {
              system = config.system or "x86_64-linux";
              config.allowUnfree = true;
            };
            extraSpecialArgs = { inherit inputs; };
            modules = [
              (homeDir + "/${name}")
            ];
          };
        }
      ) (builtins.attrNames (builtins.readDir homeDir));
      homes = builtins.filter (home: home.name != "modules") allHomes;
    in

    builtins.listToAttrs (
      map (home: {
        name = home.name;
        value = home.config;
      }) homes
    );
}
