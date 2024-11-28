{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./plugins
    ./keymaps.nix
    ./options.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
  };
}
