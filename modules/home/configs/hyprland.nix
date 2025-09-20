{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cursorTheme = "Bibata-Modern-Classic";
  cursorSize = 20;
  cfg = config.hm.configs.hyprland;
in
{
  options.hm.configs.hyprland = {
    enable = mkEnableOption "Enable Hyprland configs";
    laptop = mkEnableOption "Enable laptop specific configs, such as brightness control binds.";
    hyprsunset = mkEnableOption "Enable automatic Hyprsunset";
    monitors = mkOption {
      type = types.listOf types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.laptop {
      wayland.windowManager.hyprland.settings.binde = [
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
      ];
    })
    (mkIf cfg.hyprsunset {
      services.hyprsunset = {
        enable = true;
        transitions = {
          sunrise = {
            calendar = "*-*-* 06:00:00";
            requests = [
              [
                "temperature"
                "6000"
              ]
            ];
          };
          sunset = {
            calendar = "*-*-* 21:00:00";
            requests = [
              [
                "temperature"
                "3000"
              ]
            ];
          };
        };
      };
    })
    {
      home = {
        packages = with pkgs; [
          wl-clipboard
          cliphist
          wofi
          hyprshot
          hyprpolkitagent
        ];

        # pointerCursor = {
        #   gtk.enable = true;
        #   package = pkgs.bibata-cursors;
        #   name = cursorTheme;
        #   size = cursorSize;
        # };
      };

      # gtk = {
      #   enable = true;

      #   theme = {
      #     package = pkgs.arc-theme;
      #     name = "Arc-Dark";
      #   };

      #   iconTheme = {
      #     package = pkgs.papirus-icon-theme;
      #     name = "Papirus";
      #   };
      # };

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          env = [ "XCURSOR_SIZE, ${toString cursorSize}" ];

          exec-once = [
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            "systemctl --user start hyprpolkitagent"
            "systemctl --user start swww-daemon"
            "desktop"
            "spotify --ozone-platform=wayland"
            "vesktop --ozone-platform=wayland"
          ];

          monitor = mkIf (cfg.monitors != null) cfg.monitors;

          general = {
            gaps_in = 2;
            gaps_out = 4;
            border_size = 2;

            # "col.active_border" = "rgb(ca4b33) rgb(ed7532) rgb(f19c4e) rgb(ed7532) rgb(ca4b33) 45deg";
            # "col.inactive_border" = "rgb(749182) rgb(4a7473) rgb(7f9985) rgb(7f9985) rgb(467374) 45deg";

            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            # shadow = {
            #   enabled = true;
            #   range = 4;
            #   render_power = 3;
            #   color = "rgba(1a1a1aee)";
            # };

            blur = {
              enabled = true;
              size = 3;
              passes = 1;

              vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = true;

            bezier = [
              "myBezier, 0.12, 0, 0.39, 0"
              "overshot, 0.05, 0.9, 0.1, 1.05"
            ];

            animation = [
              "windowsMove, 1, 5, default"
              "windowsIn, 1, 5, default, slide"
              "windowsOut, 1, 5, default, slide"
              "border, 1, 10, default"
              "workspaces, 1, 6, overshot, slidevert"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = true;
          };

          input = {
            kb_layout = "us";
            kb_options = "ctrl:nocaps";

            follow_mouse = 1;

            sensitivity = 0;

            touchpad = {
              natural_scroll = false;
            };
          };

          "$mod" = "SUPER";
          bind =
            [
              "$mod, Return, exec, kitty"

              "$mod, Q, killactive"
              "$mod, F, togglefloating,"
              "$mod, P, pseudo,"
              "$mod, J, togglesplit,"

              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"

              ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"

              ", XF86AudioPrev, exec, playerctl previous"
              ", XF86AudioPlay, exec, playerctl play-pause"
              ", XF86AudioNext, exec, playerctl next"

              "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

              "$mod, S, exec, hyprshot --output-folder ~/Pictures/Screenshots --freeze -m output -m active --silent"
              "$mod CONTROL, S, exec, hyprshot --output-folder ~/Pictures/Screenshots --freeze -m window  --silent"
              "$mod SHIFT, S, exec, hyprshot --output-folder ~/Pictures/Screenshots --freeze -m region --silent"

              (mkIf config.hm.programs.ags.enable "$mod, Tab, exec, ags toggle launcher")

              "$mod, 0, workspace, 10"
              "$mod SHIFT, 0, movetoworkspace, 10"
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            ));

          binde = [
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 10%-"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 10%+"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
        };
        extraConfig = mkIf cfg.laptop ''
          # window resize
          bind = $mod, R, submap, resize

          submap = resize
          binde = , right, resizeactive, 10 0
          binde = , left, resizeactive, -10 0
          binde = , up, resizeactive, 0 -10
          binde = , down, resizeactive, 0 10
          bind = , escape, submap, reset
          submap = reset
        '';
      };
    }
  ]);
}
