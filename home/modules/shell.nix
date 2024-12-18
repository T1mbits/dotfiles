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
      settings = builtins.fromJSON ''
              {
          "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
          "secondary_prompt": {
            "template": "❯❯ ",
            "foreground": "magenta",
            "background": ""
          },
          "transient_prompt": {
            "template": "❯ ",
            "foreground": "default",
            "background": ""
          },
          "console_title_template": "{{ .Shell }} in {{ .PWD }}",
          "blocks": [
            {
              "type": "prompt",
              "alignment": "left",
              "segments": [
                {
                  "properties": {
                    "style": "full"
                  },
                  "style": "plain",
                  "template": "{{ .Path }}",
                  "foreground": "lightBlue",
                  "background": "",
                  "type": "path"
                },
                {
                  "properties": {
                    "fetch_status": true
                  },
                  "style": "plain",
                  "foreground": "darkGray",
                  "background": "",
                  "type": "git"
                }
              ],
              "newline": true
            },
            {
              "type": "rprompt",
              "alignment": "right",
              "segments": [
                {
                  "properties": {
                    "style": "roundrock",
                    "threshold": 0
                  },
                  "style": "plain",
                  "template": "{{ .FormattedMs }} ",
                  "foreground": "yellow",
                  "background": "",
                  "type": "executiontime"
                }
              ]
            },
            {
              "type": "prompt",
              "alignment": "left",
              "segments": [
                {
                  "style": "plain",
                  "template": "{{ if .SSHSession }}\ueba9 {{ end }}{{ .UserName }}@{{ .HostName }}",
                  "foreground": "white",
                  "background": "",
                  "type": "session"
                },
                {
                  "style": "plain",
                  "template": " ❯",
                  "foreground": "",
                  "background": "",
                  "type": "text",
                  "foreground_templates": [
                    "{{ if ne .Code 0 }}red{{ end }}",
                    "{{ if and (eq .Code 0) .Root }}lightYellow{{ end }}",
                    "{{ if eq .Code 0 }}magenta{{ end }}"
                  ]
                }
              ],
              "newline": true
            }
          ],
          "version": 3,
          "final_space": true
        }
      '';
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
