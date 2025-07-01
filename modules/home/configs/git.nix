{
  config,
  lib,
  self,
  ...
}:
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

      aliases = {
        lg = "log --graph --relative-date --pretty=format:'%C(auto)%h %d %C(reset blue)(%ar) %C(bold yellow)%an%C(reset) %s'";
        lgd = "log --graph --pretty=format:'%C(yellow)commit %H %C(auto)%d%n%C(bold magenta)Author:    %an <%ae> %C(reset)on %C(blue)%aD%n%C(bold green)Committer: %cn <%ce> %C(reset)on %C(blue)%aD%n%n    %B%n'";
        lgds = "log --graph --pretty=format:'%C(yellow)commit %H %C(auto)%d%n%C(bold magenta)Author:    %an <%ae> %C(reset)on %C(blue)%aD%n%C(bold green)Committer: %cn <%ce> %C(reset)on %C(blue)%aD%n%C(red)%GG%n    %B%n'";
      };

      extraConfig = {
        gpg = {
          format = "ssh";
          ssh = {
            program = "ssh-keygen";
            allowedSignersFile = "${self}/secrets/ssh/allowed_signers";
          };
        };
      };
    };
  };
}
