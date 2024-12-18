{ pkgs, ... }:
{
  imports = [ ../. ];

  networking.hostName = "serverfred";

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.Timbits = {
    isNormalUser = true;
    home = "/home/Timbits";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment = {
    # pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      vim
      home-manager
      git
      headscale
    ];
  };

  systemd.services.blank-frame-buffer = {
    description = "Turn off laptop display on boot by blanking the frame buffer";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/bin/bash -c 'echo 1 > /sys/class/graphics/fb0/blank'";
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 ];

  services = {
    openssh.enable = true;
    # headscale = {
    #   enable = true;
    #   settings = {
    #     server_url = "https://nixfred.tail5d9d53.ts.net:443";
    #     address = "0.0.0.0:443";
    #     dns = {
    #       magic_dns = true;
    #       base_domain = "headscale.tail5d9d53.ts.net";
    #     };
    #   };
    # };
  };
}