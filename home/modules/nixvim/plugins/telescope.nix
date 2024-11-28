{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
  ];

  programs.nixvim.plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>b" = "buffers";
      "<leader>fd" = "diagnostics";
      "<leader>ff" = "find_files";
      "<C-f>" = "live_grep";
    };

    settings.defaults = {
      file_ignore_patterns = [
        "^.git/"
        "^@girs/"
        "^node_modules/"
        "^target/"
      ];
      set_env.COLORTERM = "truecolor";
    };
  };
}
