{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hm.configs.zsh;
in
{
  options.hm.configs.zsh = {
    enable = mkEnableOption "Enable zsh configs";

    oh-my-posh = mkOption {
      type = types.bool;
      default = true;
      description = "Use oh-my-posh for a custom prompt";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.oh-my-posh {
      programs.oh-my-posh = {
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
    })

    {
      home.packages = with pkgs; [
        zsh-fzf-tab
        zsh-vi-mode
        zsh-fzf-history-search
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
            source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
            source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
            source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.zsh

            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*' menu no

            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
            zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
          '';
        };

        zoxide.enableZshIntegration = true;
      };
    }

  ]);

}
