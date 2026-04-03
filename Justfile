# hostname := "nebula"

# Most used nix commands
mod nix

# List all the just commands
[private]
default:
    @just --list
    @echo ""
    @just --list nix --list-heading $'Nix submodule recipes:\n'

# List all generations of the system profile
[group('nix')]
history:
    nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
    nix repl -f flake:nixpkgs

# Remove generations older than 3 days and collect garbage
[group('nix')]
clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 3d
    sudo -H nix-collect-garbage --delete-older-than 3d

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
    ls -al /nix/var/nix/gcroots/auto/

# Lint all .nix files with nil and nixd
[group('nix')]
lint:
    #!/usr/bin/env bash
    set -euo pipefail
    errors=0
    while IFS= read -r f; do
      out=$(nil diagnostics "$f" 2>&1)
      if [ -n "$out" ]; then
        echo "$out"
        errors=$((errors + 1))
      fi
    done < <(fd -e nix)
    [ $errors -eq 0 ] && echo "No issues found."

[group('nix')]
format:
    alejandra .
