{
  pkgs,
  ...
}:
{
  imports = [
    ../home/hyprland.nix
    ../home/terminal.nix
    # ../home/spotify.nix
  ];

  home = {
    # DO NOT CHANGE THIS VERSION NUMBER UNLESS YOU KNOW WHAT YOU'RE DOING
    stateVersion = "24.11";
    username = "Timbits";
    homeDirectory = "/home/Timbits";

    packages = with pkgs; [
      ranger
      tmux
      firefox
      vesktop # discord never krisp :(
      nil
      nixfmt-rfc-style
      bash-language-server
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
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    vscode.enable = true;
    home-manager.enable = true;
  };
}
