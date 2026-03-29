default:update

update:
  nix profile upgrade nvim

try:
  just update
  nvim
