local lsp = require('lspconfig')

lsp.nil_ls.setup {
  settings = {
    nix = {
      flake = {
        -- calls `nix flake archive` to put a flake and its output to store
        autoArchive = true,
      },
    },
  },
}
