# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins

    # Colorscheme
    gruvbox-nvim

    # Language
    nvim-lspconfig
    treesitter-modules-nvim # syntax tree parser | https://github.com/MeanderingProgrammer/treesitter-modules.nvim/
    ts-comments-nvim # enhance Neovim's native comments | https://github.com/folke/ts-comments.nvim/
    nvim-treesitter-context # nvim-treesitter-context
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/

    # git integration plugins
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/

    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nui-nvim # UI Component Library | https://github.com/MunifTanjim/nui.nvim
    noice-nvim # Highly experimental UI plugin | https://github.com/folke/noice.nvim/
    yazi-nvim # Use yazi within neovim

    blink-cmp # Completion plugin | https://github.com/saghen/blink.cmp
    luasnip # snippet engine | https://github.com/l3mon4d3/luasnip/
    friendly-snippets # snippets | https://github.com/rafamadriz/friendly-snippets/

    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/

    # navigate your code with search labels, enhanced character motions, and Treesitter integration
    flash-nvim # https://github.com/folke/flash.nvim/

    trouble-nvim # A pretty diagnostics list | https://github.com/folke/trouble.nvim/

    # Mini.nvim
    mini-pairs # https://github.com/nvim-mini/mini.pairs/
    mini-icons # https://github.com/nvim-mini/mini.icons/
    mini-ai # https://github.com/nvim-mini/mini.ai/

    # Code formatting + linting
    conform-nvim # Lightweight yet powerful formatter | https://github.com/stevearc/conform.nvim/
    nvim-lint # An asynchronous linter | https://codeberg.org/mfussenegger/nvim-lint/

    # navigation/editing enhancement plugins
    grug-far-nvim # Find And Replace plugin for neovim | https://github.com/MagicDuck/grug-far.nvim
    hop-nvim # https://github.com/smoka7/hop.nvim

    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    nvim-surround # https://github.com/kylechui/nvim-surround/

    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    lazydev-nvim # Faster LuaLS setup for Neovim | https://github.com/folke/lazydev.nvim/
    snacks-nvim # A collection of small QoL plugins | https://github.com/folke/snacks.nvim/
    comment-box-nvim # draw boxes and lines in comments | https://github.com/LudoPinelli/comment-box.nvim/
    nvim-highlight-colors # Highlight colors | https://github.com/brenoprata10/nvim-highlight-colors/
    todo-comments-nvim # Highlight, list and search todo comments | https://github.com/folke/todo-comments.nvim/
    persistence-nvim # Simple session management | https://github.com/folke/persistence.nvim/

    # libraries that other plugins depend on
    plenary-nvim
    nvim-web-devicons # Nerd Font icons | https://github.com/nvim-tree/nvim-web-devicons
    vim-repeat

    which-key-nvim

    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nil # nix LSP
    rust-analyzer
  ];
in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
