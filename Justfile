hostname := "nebula"

# List all the just commands
default:
  @just --list

############################################################################
#
#  nix related commands
#
############################################################################

alias up := upgrade

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
    @just update && just switch && just gc

# Garbage collect all unused nix store entries
[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 3d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 3d

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 3d

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
  ls -al /nix/var/nix/gcroots/auto/
