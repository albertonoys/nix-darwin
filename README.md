# NixOS Configuration for MacOS aarch64

NixOS configuration (based on [nixos-config](https://github.com/divnix/nixos-config)) tailored for MacOS aarch64, utilizing Nix flakes and [nix-darwin](https://github.com/LnL7/nix-darwin) for package management and system configuration.

## Directory Structure

- `apps/`: Scripts for building and managing the system.
- `hosts/`: Host-specific configurations.
- `modules/`:
  - `darwin/`: MacOS-specific configurations.
    - `brews.nix`: Homebrew brews.
    - `casks.nix`: Homebrew casks.
    - `files.nix`: File management and configuration.
    - `home-manager.nix`: Home Manager configuration.
    - `packages.nix`: Nixpkgs packages.
- `flake.nix`: Flake configuration.

### Building

```bash
nix run .#build
```

### Switching

```bash
nix run .#build-switch
```
