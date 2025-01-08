{ pkgs, ... }:
{
  extraPlugins = [ pkgs.vimPlugins.bluloco-nvim ];
  extraConfigLuaPre = ''require('bluloco').setup({})'';
}
