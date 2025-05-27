{ config, lib, ... }:
with lib;
let
  cfg = config.hm.configs.git;
in
{
  options.hm.configs.git = {
    enable = mkEnableOption "Enable git";

    signCommits = mkOption {
      type = types.bool;
      default = true;
      description = "Enable automatic signing of commits using SSH";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Timbits";
      userEmail = "timbits1123@gmail.com";

      signing = mkIf (config.hm.services.ssh.enable && cfg.signCommits) {
        key = "${config.hm.ssh.public.git-signing}";
        signByDefault = true;
      };

      extraConfig = {
        gpg.format = "ssh";
        gpg."ssh".program = "ssh-keygen";
      };
    };
  };
}
