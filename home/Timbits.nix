{
  inputs,
  pkgs,
  ...
}:
let
  nixbits = import ../pkgs/nixbits { inherit pkgs; };
in
{
  imports = [
    ./modules
    inputs.agenix.homeManagerModules.default
  ];

  age.secrets.test.file = ../secrets/test.age;

  home = {
    # DO NOT CHANGE THIS VERSION NUMBER UNLESS YOU KNOW WHAT YOU'RE DOING
    stateVersion = "24.11";
    username = "Timbits";
    homeDirectory = "/home/Timbits";

    packages = with pkgs; [
      bottom
      ranger
      tmux
      gitui

      firefox
      vesktop # discord never krisp :(
      ffmpeg-full
      gimp

      nixbits

      inputs.timbits-nixvim.packages.${pkgs.system}.default

      dotnet-sdk_8
      omnisharp-roslyn
      rustup
      nil
      nixfmt-rfc-style
      bash-language-server

      wineWowPackages.waylandFull
      mono
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Timbits";
      userEmail = "timbits1123@gmail.com";
    };
    vscode.enable = true;
    home-manager.enable = true;
    obs-studio.enable = true;
  };
}
