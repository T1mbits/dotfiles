{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.programs.yazi;
in
{
  options.hm.programs.yazi = {
    enable = mkEnableOption "Enable yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        manager = {
          show_hidden = true;
        };
      };

      keymap = {
        manager.prepend_keymap = [
          {
            on = [ "m" ];
            run = "plugin bookmarks save";
            desc = "Save current position as a bookmark";
          }
          {
            on = [ "'" ];
            run = "plugin bookmarks jump";
            desc = "Jump to a bookmark";
          }
          {
            on = [
              "b"
              "d"
            ];
            run = "plugin bookmarks delete";
            desc = "Delete a bookmark";
          }
          {
            on = [
              "b"
              "D"
            ];
            run = "plugin bookmarks delete_all";
            desc = "Delete all bookmarks";
          }
        ];
      };

      plugins = {
        bookmarks = pkgs.fetchFromGitHub {
          owner = "dedukun";
          repo = "bookmarks.yazi";
          rev = "a70648a22b609113ed8fe3f940e262c57fc1195f";
          sha256 = "sha256-tsSSLyljSrXlsA/moiGzjACxA80vsfOCTIJQrJ83Yd0=";
        };
      };

      initLua = ''
        require("bookmarks"):setup({
          last_directory = { enable = true, persist = true, mode = "dir" },
          persist = "vim",
        })
      '';
    };
  };
}
