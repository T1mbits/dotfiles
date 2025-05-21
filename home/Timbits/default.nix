{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    # DO NOT CHANGE THIS VERSION NUMBER UNLESS YOU KNOW WHAT YOU'RE DOING
    stateVersion = "24.11";

    packages = with pkgs; [
      bottom
      gitui

      firefox
      ffmpeg-full
      imagemagick
      gimp
      krita
      vlc

      # inputs.timbits-nixvim.packages.${pkgs.system}.default

      dotnet-sdk_8
      omnisharp-roslyn
      rustup
      nil
      nixfmt-rfc-style
      bash-language-server

      wineWowPackages.waylandFull
      mono

      python3
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  hm = {
    configs = {
      zsh.enable = true;
      kitty.enable = true;

      hyprland = {
        enable = true;
        laptop = true;
        hyprsunset = true;
        monitors = [
          "DP-4, 1920x1080, 0x0, 1, bitdepth, 8"
          "eDP-1, 2160x1440, 1920x0, 1.5, bitdepth, 8"
        ];
      };

      nixCats.enable = true;
      stylix = {
        enable = true;
        theme = "outskirts-orange";
        targetsToIgnore = [
          [
            "hyprland"
            "hyprpaper"
          ]
          [ "vscode" ]
          [ "vesktop" ]
        ];
      };
      tmux.enable = true;
    };

    programs = {
      ags.enable = true;
      nixbits.enable = true;
      prism-launcher.enable = true;
      shell-utils.enable = true;
      spotify.enable = true;
      spotify-player = {
        enable = false;
        clientId = "f999b60be23f46c394ba8c738deea165";
        deviceName = "nixfred spotify_player";
      };
      todocli.enable = true;
      vesktop = {
        enable = true;

        # I don't use THAT many plugins...
        plugins = [
          "BetterGifPicker"
          "CallTimer"
          "ClearURLs"
          "CopyUserURLs"
          "DontRoundMyTimestamps"
          "EmoteCloner"
          "FakeNitro"
          "FavoriteEmojiFirst"
          "FavoriteGifSearch"
          "FixSpotifyEmbeds"
          "MessageLinkEmbeds"
          "MessageLogger"
          "NoF1"
          "PreviewMessage"
          "ReverseImageSearch"
        ];
      };
      yazi.enable = true;
    };

    services.swww.enable = true;
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
