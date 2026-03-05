default:update

update:
  nix profile upgrade Neovim

try:
  just update
  nvim
