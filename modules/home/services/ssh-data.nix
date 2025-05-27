{
  config,
  lib,
  self,
  ...
}:
with lib;
let
  sshDir = "${self}/secrets/ssh";

  allFiles = builtins.attrNames (builtins.readDir sshDir);

  sshFiles = builtins.filter (
    file:
    file != null && (builtins.match ".*\\.pub$" file != null || builtins.match ".*\\.age$" file != null)
  ) allFiles;

  sshKeyExtensionFilter =
    fileExtension:
    (builtins.filter (
      file: file != null && (builtins.match ".*\\.${fileExtension}$" file != null)
    ) sshFiles);

  privateSshFiles = sshKeyExtensionFilter "age";

  privateSshKeySecretSetup = builtins.listToAttrs (
    map (keyFile: {
      name = "${(builtins.replaceStrings [ ".age" ] [ "" ] keyFile)}-ssh";
      value = {
        file = "${sshDir}/${keyFile}";
      };
    }) privateSshFiles
  );

  privateSshKeyPaths = builtins.listToAttrs (
    map (
      keyFile:
      let
        base = (builtins.replaceStrings [ ".age" ] [ "" ] keyFile);
      in
      {
        name = base;
        value = config.age.secrets."${base}-ssh".path;
      }
    ) privateSshFiles
  );

  publicSshKeyPaths = builtins.listToAttrs (
    map (keyFile: {
      name = "${builtins.replaceStrings [ ".pub" ] [ "" ] keyFile}";
      value = "${sshDir}/${keyFile}";
    }) (sshKeyExtensionFilter "pub")
  );
in
{
  options.hm.ssh = mkOption {
    type =
      with types;
      submodule {
        options = {
          public = mkOption {
            type = attrsOf str;
            default = { };
            description = "Public SSH keys";
          };
          private = mkOption {
            type = attrsOf str;
            default = { };
            description = "Private SSH keys";
          };
        };
      };
    default = { };
    description = "Collection of ssh keys from secrets/ssh";
  };

  config = {
    age = {
      identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      secrets = privateSshKeySecretSetup;
    };

    hm.ssh = {
      public = publicSshKeyPaths;
      private = privateSshKeyPaths;
    };
  };
}
