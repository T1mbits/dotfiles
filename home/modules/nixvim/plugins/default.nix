{ pkgs, ... }:
{
  imports = [
    ./lsp.nix
    ./telescope.nix
    ./treesitter.nix
    #./todo.nix
  ];

  programs.nixvim = {
    colorscheme = "bluloco";

    plugins = {
      comment.enable = true;

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "-";
        };
      };

      lualine.enable = true;

      nvim-autopairs.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };

      oil.enable = true;

      trim = {
        enable = true;
        settings = {
          ft_blocklist = [
            "TelescopePrompt"
          ];
          highlight = true;
        };
      };

      web-devicons.enable = true;
    };

    extraPlugins = with pkgs; [ vimPlugins.bluloco-nvim ];
    extraConfigLuaPre = "require('bluloco').setup({style = 'dark', transparent =  false, italics = true})";
  };
}
