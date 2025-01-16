{ dirs }:
let
  mkHmModules =
    drv:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.hm.drv.${drv};
    in
    {
      options.hm.drv.${drv} = {
        enable = mkEnableOption "Build ${drv} and add the package via `home.packages`";
      };

      config = mkIf cfg.enable {
        home.packages = [ (import "${dirs.derivations}/${drv}" pkgs) ];
      };
    };

  mkNixosModules =
    drv:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.drv.${drv};
    in
    {
      options.drv.${drv} = {
        enable = mkEnableOption "Build ${drv} and add the package via `environment.systemPackages`";
      };

      config = mkIf cfg.enable {
        environment.systemPackages = [ (import "${dirs.derivations}/${drv}" pkgs) ];
      };
    };

  mkDrvModules =
    mkFunc: map (dir: mkFunc dir) (builtins.attrNames (builtins.readDir dirs.derivations));
in
{
  nixosDrvModules = mkDrvModules mkNixosModules;
  homeDrvModules = mkDrvModules mkHmModules;
}
