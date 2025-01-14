{
  nixpkgs = "nixpkgs";
  system = "x86_64-linux";

  users = [ "Timbits" ];
  restrictedGroups = {
    allowedUsers = [ "Timbits" ];
    groups = [
      "root"
      "wheel"
      "disk"
      "networkmanager"
      "tty"
      "docker"
    ];
  };
}
