{
  home-manager = "home-manager";
  nixpkgs = "nixpkgs";
  system = "x86_64-linux";

  usersConfig = {
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
    ];
    shell = "zsh";
  };
}
