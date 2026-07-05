{
  description = "Neovim derivation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{
      nixpkgs,
      systems,
      self,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };

      overlays = [
        # Import the overlay, so that the final Neovim derivation(s) can be accessed via pkgs.<nvim-pkg>
        neovim-overlay
        # This adds a function can be used to generate a .luarc.json
        # containing the Neovim API all plugins in the workspace directory.
        # The generated file can be symlinked in the devShell's shellHook.
        inputs.gen-luarc.overlays.default
      ];

      mkPkgs =
        system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

      forEachPkgs = f: lib.genAttrs (import systems) (system: f (mkPkgs system));
    in
    {
      packages = forEachPkgs (pkgs: {
        default = pkgs.nvim-pkg;
        nvim = pkgs.nvim-pkg;
        mdvim = pkgs.nvim-pkg-markdown;
      });

      devShells = forEachPkgs (pkgs: {
        default = pkgs.mkShell {
          name = "nvim-devShell";
          buildInputs = with pkgs; [
            # Tools for Lua and Nix development, useful for editing files in this repo
            lua-language-server
            nil
            stylua
            luajitPackages.luacheck
            nvim-dev
          ];
          shellHook = ''
            # symlink the .luarc.json generated in the overlay
            ln -fs ${pkgs.nvim-luarc-json} .luarc.json
            # allow quick iteration of lua configs
            ln -Tfns $PWD/nvim ~/.config/nvim-dev
          '';
        };
      });

      # You can add this overlay to your NixOS configuration
      overlays.default = neovim-overlay;
    };
}
