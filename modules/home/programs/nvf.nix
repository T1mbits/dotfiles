{
  config,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.hm.programs.nvf;
in {
  imports = [inputs.nvf.homeManagerModules.default];

  options.hm.programs.nvf = {
    enable = mkEnableOption "Enable nvf as the active (neo)vim configuration";
  };

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings.vim = {
        viAlias = true;
        vimAlias = true;

        spellcheck.enable = true;

        lsp = {
          formatOnSave = true;

          lightbulb.enable = true;
          lspkind.enable = true;
          lsplines.enable = true;
          lspSignature.enable = true;
          otter-nvim.enable = true;
          trouble.enable = true;
        };

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          bash.enable = true;
          markdown.enable = true;
          nix = {
            enable = true;
            format.type = "nixfmt";
          };
          rust = {
            enable = true;
            crates.enable = true;
          };
        };

        visuals = {
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          indent-blankline.enable = true;

          cellular-automaton.enable = true;
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "base16";
          };
        };

        theme = {
          enable = true;
          name = "base16";
          base16-colors = with config.lib.stylix.colors; {
            inherit
              base00
              base01
              base02
              base03
              base04
              base05
              base06
              base07
              base08
              base09
              base0A
              base0B
              base0C
              base0D
              base0E
              base0F
              ;
          };
          transparent = true;
        };

        autopairs.nvim-autopairs.enable = true;

        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        # treesitter.context.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false;
        };

        dashboard.alpha.enable = true;

        notify.nvim-notify.enable = true;

        projects.project-nvim.enable = true;

        utility = {
          ccc.enable = false;
          surround.enable = true;
          diffview-nvim.enable = true;
        };

        notes.todo-comments.enable = true;

        ui = {
          borders.enable = false;
          colorizer.enable = true;
          illuminate.enable = true;
          fastaction.enable = true;
        };

        comments.comment-nvim.enable = true;
      };
    };
  };
}
