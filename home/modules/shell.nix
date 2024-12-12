{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    zsh-fzf-tab
    zsh-vi-mode
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };
      syntaxHighlighting.enable = true;

      history = {
        append = true;
        ignoreSpace = true;
        ignoreDups = true;
        ignoreAllDups = true;
        path = "/home/Timbits/.zsh_hist";
        save = 10000;
        size = 10000;
      };

      shellAliases = {
        c = "clear";
        cd = "z";
        eza = "eza --icons=always -b -h -l --git";
        ls = "eza --icons=always -b -h -l --git";
      };

      # zstyle ':completion:*' list-colors "${("s.:.") (builtins.readFile ./LS_COLORS.txt)}"
      initExtra = ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
      '';
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromJSON (builtins.readFile ../../themes/oh-my-posh/timbits.omp.json);
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;
    };

    ranger = {
      enable = true;
      settings = {
        preview_images = true;
        preview_images_method = "kitty";
      };
    };
  };
}
