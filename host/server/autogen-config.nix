{
  nixpkgs = "nixpkgs-stable";
  system = "x86_64-linux";

  users = [ "Serverbits" ];
  restrictedGroups = {
    allowedUsers = [ "Serverbits" ];
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
