[private]
default:
  @just --list nix

# Update all the flake inputs
[group('nix')]
update:
  nix flake update

# .#build-switch
[group('nix')]
switch:
    nix run .#build-switch

# Only apply config changes, no updating
[group('nix')]
apply:
    nix run .#build-switch-fast

# Update flake && .#build-switch && gc
[group('nix')]
upgrade:
    @just nix::update nix::switch nix::gc

# Garbage collect all unused nix store entries
[group('nix')]
gc:
    # garbage collect all unused nix store entries(system-wide)
    sudo nix-collect-garbage --delete-older-than 3d
    # garbage collect all unused nix store entries(for the user - home-manager)
    nix-collect-garbage --delete-older-than 3d
