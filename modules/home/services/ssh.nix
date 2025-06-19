{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.services.ssh;

  keyScript = pkgs.writeShellScript "add-ssh-keys" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: ''
        ${pkgs.openssh}/bin/ssh-add ${value}
      '') config.hm.ssh.private
    )
  );
in
{
  options.hm.services.ssh = {
    enable = mkEnableOption "Enable SSH agent";

    keysToLoad = mkOption {
      type = types.listOf types.string;
      default = [ ];
      description = "The name of ssh key file pairs to load from ./secrets/ssh";
    };
  };

  config = mkIf cfg.enable {
    programs.ssh.enable = true;
    services.ssh-agent.enable = true;

    systemd.user.services.add-ssh-keys = {
      Unit = {
        Description = "Add SSH keys to ssh-agent";
        After = [
          "ssh-agent.service"
          "agenix.service"
        ];
        PartOf = [ "ssh-agent.service" ];
      };
      Service = {
        ExecStart = keyScript;
        Type = "oneshot";
        RemainAfterExit = true;
        Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
      };
      Install = {
        WantedBy = [
          "default.target"
          "ssh-agent.service"
        ];
      };
    };
  };
}
