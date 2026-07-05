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
  common-plugins = with pkgs.vimPlugins; [
    catppuccin-nvim

    lazydev-nvim
    nvim-lspconfig
    nvim-treesitter.withAllGrammars # treesitter - syntax tree parser | https://github.com/MeanderingProgrammer/treesitter-modules.nvim/
    ts-comments-nvim # enhance Neovim's native comments | https://github.com/folke/ts-comments.nvim/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    blink-pairs # Pairs + rainbow pairs
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nui-nvim # UI Component Library | https://github.com/MunifTanjim/nui.nvim
    blink-cmp # Completion plugin | https://github.com/saghen/blink.cmp
    blink-cmp-dictionary
    luasnip
    friendly-snippets
    snacks-nvim # A collection of small QoL plugins | https://github.com/folke/snacks.nvim/
    nvim-highlight-colors # Highlight colors | https://github.com/brenoprata10/nvim-highlight-colors/
    nvim-surround
    # navigate your code with search labels, enhanced character motions, and Treesitter integration
    flash-nvim # https://github.com/folke/flash.nvim/
    hop-nvim
    # Code formatting + linting
    conform-nvim # Lightweight yet powerful formatter | https://github.com/stevearc/conform.nvim/
    nvim-lint # An asynchronous linter | https://codeberg.org/mfussenegger/nvim-lint/
    # libraries that other plugins depend on
    plenary-nvim
    mini-icons # https://github.com/nvim-mini/mini.icons/
    vim-repeat
    which-key-nvim
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
  ];

  normal-editor = with pkgs.vimPlugins; [
    noice-nvim # Highly experimental UI plugin | https://github.com/folke/noice.nvim/
    pretty-fold-nvim # Foldtext customization in Neovim
    blink-indent # Indentation guides
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    virt-column-nvim # Display a character as the colorcolumn.
    yazi-nvim # Use yazi within neovim
    trouble-nvim # A pretty diagnostics list | https://github.com/folke/trouble.nvim/
    mini-ai # https://github.com/nvim-mini/mini.ai/
    # navigation/editing enhancement plugins
    grug-far-nvim # Find And Replace plugin for neovim | https://github.com/MagicDuck/grug-far.nvim
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    nvim-unception
    persistence-nvim # Simple session management | https://github.com/folke/persistence.nvim/
    comment-box-nvim # draw boxes and lines in comments | https://github.com/LudoPinelli/comment-box.nvim/
    crates-nvim # A neovim plugin that helps managing crates.io dependencies | https://github.com/Saecki/crates.nvim
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
  ];

  markdown-plugins = with pkgs.vimPlugins; [
    render-markdown-nvim
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    markdownlint-cli
    lua-language-server
    stylua
    nixd # nix LSP
    nixfmt-rs
    rust-analyzer
    rustfmt
  ];

  all-plugins = common-plugins ++ normal-editor ++ markdown-plugins;
in
{
  # Main nvim derivation
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    ignoreConfigRegexes = [
      "^plugin/derivations/markdown/.*.lua"
    ];
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
  nvim-pkg-markdown = mkNeovim {
    plugins = all-plugins;

    ignoreConfigRegexes = [
    "^plugin/utils/gitsigns.lua"
    "^plugin/utils/snacks_dashboard.lua"
    "^plugin/utils/grug-far.lua"
    "^plugin/utils/comment-box.lua"
    "^plugin/ui/yazi.lua"
    "^plugin/ui/noice.lua"
    "^plugin/ui/blink-indent.lua"
    "^plugin/ui/pretty-fold.lua"
    "^plugin/ui/virt-column.lua"
    "^plugin/editor/trouble.lua"
    "^plugin/editor/persistence.lua"
    "^plugin/coding/mini.ai.lua"
    "^ftplugin/.*.lua"
    ];
    extraPackages = [ pkgs.markdownlint-cli ];
  };
}
