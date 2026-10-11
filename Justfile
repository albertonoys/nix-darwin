# Everyday commands for this nix-darwin config. Run `just` to list them.

# List recipes
[private]
default:
    @just --list

# Build and activate the current config (brew installs/removes, never upgrades)
[group('system')]
switch:
    nh darwin switch .

alias apply := switch

# Build the config without activating it
[group('system')]
build:
    nh darwin build .

# Update flake inputs (nixpkgs, home-manager, brew taps, ...)
[group('system')]
update:
    nix flake update

# Update inputs, switch, upgrade brew, then collect garbage
[group('system')]
upgrade: update switch brew-upgrade gc

# Upgrade all outdated brew formulae (incl. dependencies) and casks.
# A single failed download (flaky cask server) should not abort `upgrade`.
[group('system')]
brew-upgrade:
    -HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade --greedy --yes

# Roll back to the previous generation, or to GEN if given
[group('system')]
rollback gen="":
    sudo darwin-rebuild {{ if gen == "" { "--rollback" } else { "--switch-generation " + gen } }}

# Delete generations older than 3 days and collect garbage (system and user)
[group('maintenance')]
gc:
    sudo -H nix-collect-garbage --delete-older-than 3d
    nix-collect-garbage --delete-older-than 3d

# List system generations
[group('maintenance')]
history:
    nix profile history --profile /nix/var/nix/profiles/system

# Show auto gc roots (things keeping store paths alive)
[group('maintenance')]
roots:
    ls -al /nix/var/nix/gcroots/auto/

# Format nix and lua files
[group('dev')]
fmt:
    nix fmt

# Formatting, lints (deadnix, statix) and a full system build
[group('dev')]
check:
    nix flake check

# Open a nix repl with this flake's outputs loaded
[group('dev')]
repl:
    nix repl .
