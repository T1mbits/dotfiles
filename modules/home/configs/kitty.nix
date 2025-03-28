{ config, lib, ... }:
with lib;
let
  cfg = config.hm.configs.kitty;
in
{
  options.hm.configs.kitty = {
    enable = mkEnableOption "Enable Kitty configs";
  };

  config = mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        settings = {
          cursor_shape = "block";

          # font_family = "Fira Code";
          font_size = 11;

          symbol_map =
            let
              nerd_mappings = [
                "U+E5FA-U+E6AC"
                "U+E700-U+E7C5"
                "U+F000-U+F2E0"
                "U+E200-U+E2A9"
                "U+F0001-U+F1AF0"
                "U+E300-U+E3E3"
                "U+F400-U+F532"
                "U+2665"
                "U+26A1"
                "U+E0A3"
                "U+E0B4-U+E0C8"
                "U+E0CA"
                "U+E0CC-U+E0D4"
                "U+23FB-U+23FE"
                "U+2B58"
                "U+F300-U+F32F"
                "U+E000-U+E00A"
                "U+EA60-U+EBEB"
                "U+E276C-U+E2771"
                "U+2500-U+259F"
              ];
            in
            (builtins.concatStringsSep "," nerd_mappings) + " Symbols Nerd Font Mono";
          # symbol_map = let nonicon_mappings = [
          #   "U+F102"
          #   "U+F116-U+F118"
          #   "U+F12F"
          #   "U+F13E"
          #   "U+F1AF"
          #   "U+F1BF"
          #   "U+F1CF"
          #   "U+F1FF"
          #   "U+F21F-U+F220"
          #   "U+F22E-U+F22F"
          #   "U+F23F"
          #   "U+F24F"
          #   "U+F25F"
          # ];in
          # ((builtins.concatStringsSep "," nonicon_mappings) + " nonicons")

          # background_opacity = 0.9;

          # # TODO replace with stylix, currently uses bluloco theme
          # foreground = "#b9c0cb";
          # background = "#282c34";
          # selection_foreground = "#282c34";
          # selection_background = "#b9c0cb";

          # cursor = "#ffcc00";
          # cursor_text_color = "#282c34";

          # url_color = "#3375FF";

          # active_tab_foreground = "#b9c0cb";
          # active_tab_background = "#44474D";
          # inactive_tab_foreground = "#6B6F79";
          # inactive_tab_background = "#1A1F27";
          # tab_bar_background = "#23272F";
          # tab_bar_margin_color = "none";

          # #: black
          # color0 = "#41444d";
          # color8 = "#8f9aae";

          # #: red
          # color1 = "#fc2f52";
          # color9 = "#ff6480";

          # #: green
          # color2 = "#25a45c";
          # color10 = "#3fc56b";

          # #: yellow
          # color3 = "#ff936a";
          # color11 = "#f9c859";

          # #: blue
          # color4 = "#3476ff";
          # color12 = "#10b1fe";

          # #: magenta
          # color5 = "#7a82da";
          # color13 = "#ff78f8";

          # #: cyan
          # color6 = "#4483aa";
          # color14 = "#5fb9bc";

          # #: white
          # color7 = "#cdd4e0";
          # color15 = "#ffffff";
        };
      };
    };
  };
}
