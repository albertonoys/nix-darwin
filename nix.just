[private]
default:
    @just --list nix

# Update all the flake inputs
[group('nix')]
update:
    nix flake update

# Build and activate the current config (brew installs/removes, never upgrades)
[group('nix')]
switch:
    nh darwin switch .

alias apply := switch

# Build the config without activating it
[group('nix')]
build:
    nh darwin build .

# Roll back to the previous generation, or to GEN if given
[group('nix')]
rollback gen="":
    sudo darwin-rebuild {{ if gen == "" { "--rollback" } else { "--switch-generation " + gen } }}

# Update flake && switch && upgrade brew && gc
[group('nix')]
upgrade:
    @just nix::update nix::switch nix::brew-upgrade nix::gc

# Upgrade all outdated brew formulae (incl. dependencies) and casks
[group('nix')]
brew-upgrade:
    HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade --greedy

# Garbage collect all unused nix store entries
[group('nix')]
gc:
    # garbage collect all unused nix store entries(system-wide)
    sudo -H nix-collect-garbage --delete-older-than 3d
    # garbage collect all unused nix store entries(for the user - home-manager)
    nix-collect-garbage --delete-older-than 3d
