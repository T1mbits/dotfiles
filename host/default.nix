{
  inputs,
  system,
  ...
}:
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = [ inputs.agenix.packages.${system}.default ];

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    openssh.enable = true;
  };
}
