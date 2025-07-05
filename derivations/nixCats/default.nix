{
  inputs,
  ...
}@attrs:
let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixCats) utils;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  extra_pkg_config = { };
  dependencyOverlays = [
    (utils.standardPluginOverlay inputs)
  ];

  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkNvimPlugin,
      ...
    }@packageDef:
    {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          ripgrep
          fd
        ];

        format = with pkgs; [
          csharpier
          stylua
          mdformat
          nixfmt-rfc-style
        ];

        rust = with pkgs; [ ];

        csharp = with pkgs; [
          csharp-ls
          dotnet-sdk_9
        ];

        neonixdev = with pkgs; [
          nixd
          nix-doc
          lua-language-server
        ];
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          lze
          plenary-nvim
          nvim-web-devicons
        ];
      };

      optionalPlugins = with pkgs.vimPlugins; {
        general = {
          cmp = [
            nvim-cmp
            luasnip
            friendly-snippets
            cmp_luasnip
            cmp-buffer
            cmp-path
            cmp-nvim-lua
            cmp-nvim-lsp
            cmp-cmdline
            cmp-nvim-lsp-signature-help
            lspkind-nvim
          ];

          format = [
            conform-nvim
          ];

          fun = [
            cellular-automaton-nvim
          ];

          telescope = [
            telescope-fzf-native-nvim
            telescope-nvim
          ];

          treesitter = [
            nvim-treesitter.withAllGrammars
          ];

          ui = [
            alpha-nvim
            dressing-nvim
            fidget-nvim
            gitsigns-nvim
            indent-blankline-nvim
            lualine-nvim
            render-markdown-nvim
            todo-comments-nvim
          ];

          utils = [
            comment-nvim
            harpoon
            nvim-autopairs
            project-nvim
            nvim-surround
            trouble-nvim
          ];

          lsp = [
            nvim-lspconfig
            lazydev-nvim
          ];

          binds = [
            which-key-nvim
          ];
        };
      };

      sharedLibraries = {
        general = with pkgs; [
        ];
      };

      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      extraPython3Packages = {
        test = (_: [ ]);
      };
      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };
    };

  packageDefinitions = {
    nvim =
      { pkgs, ... }:
      {
        settings = {
          wrapRc = true;
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          aliases = [
            "n"
            "vim"
            "vi"
          ];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
        };
        categories = {
          general = true;
          format = true;
          neonixdev = true;
          csharp = true;
        };
        extra = {
          # to keep the categories table from being filled with non category things that you want to pass
          # there is also an extra table you can use to pass extra stuff.
          # but you can pass all the same stuff in any of these sets and access it in lua
          nixdExtras = {
            nixpkgs = nixpkgs;
          };
        };
      };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nvim";
in

forEachSystem (
  system:
  let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit
        nixpkgs
        system
        dependencyOverlays
        ;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = '''';
      };
    };

  }
)
// (
  let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
  in
  {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  }
)
