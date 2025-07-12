{ config, lib, ... }:
with lib;
let
  cfg = config.hm.configs.tmux;
in
{
  options.hm.configs.tmux = {
    enable = mkEnableOption "Enable tmux and its config";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 0;
      shortcut = "a";
      keyMode = "vi";

      extraConfig = ''
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        bind r source-file ~/.config/tmux/tmux.conf

        setw -g automatic-rename off
        set -g renumber-windows on
        set -g mouse on
        set -g set-titles on

        bind -n M-h select-pane -L
        bind -n M-l select-pane -R
        bind -n M-k select-pane -U
        bind -n M-j select-pane -D

        bind -n M-H resize-pane -L
        bind -n M-L resize-pane -R
        bind -n M-K resize-pane -U
        bind -n M-J resize-pane -D

        bind -n C-M-H resize-pane -L 5
        bind -n C-M-L resize-pane -R 5
        bind -n C-M-K resize-pane -U 5
        bind -n C-M-J resize-pane -D 5
      '';
    };
  };
}
