# nix-darwin config

macOS (aarch64) system and user configuration for the `nebula` MacBook, built
with Nix flakes, [nix-darwin](https://github.com/nix-darwin/nix-darwin),
[home-manager](https://github.com/nix-community/home-manager) and
[nix-homebrew](https://github.com/zhaofengli/nix-homebrew). Nix itself is
[Determinate Nix](https://determinate.systems/nix/).

## Layout

```
flake.nix               inputs and the nebula darwinSystem
hosts/nebula/           identity: hostname, user, git name/email
modules/darwin/         system level (nix-darwin)
  defaults.nix            macOS system.defaults
  fonts.nix               fonts.packages
  home-manager.nix        wires modules/home in for the primary user
  homebrew.nix            casks, brews, pinned taps, quarantine stripping
  nix.nix                 Determinate nix.custom.conf, nixpkgs config
  security.nix            Touch ID sudo, scoped passwordless sudo
  system.nix              user, hostname, shells
modules/home/           user level (home-manager)
  default.nix             programs and the my.repoDir option
  dotfiles.nix            links dotfiles/ into ~/.config
  packages.nix            CLI packages
  programs/               fish, zsh, git, neovim, shared aliases/env
dotfiles/               app configs, symlinked (edit in place, no rebuild)
treefmt.nix             formatters and linters for `nix fmt` / `nix flake check`
Justfile                everyday commands
```

## Where things go

- CLI tools: nixpkgs, in `modules/home/packages.nix`.
- GUI apps: Homebrew casks, in `modules/darwin/homebrew.nix`.
- Homebrew formulae: only when nixpkgs lacks or breaks a tool on darwin, another
  brew already depends on it, or it moves fast and benefits from brew bottles.
  Say why in a trailing comment.
- App config files: `dotfiles/<app>/`, linked file by file into `~/.config/<app>/`.
  nvim is linked as a whole directory.

## Commands

Run `just` for the full list. The common ones (fish functions in parentheses):

| Command | What it does |
|---|---|
| `just switch` (`nix-apply-config`) | build and activate; brew installs/removes but never upgrades |
| `just upgrade` (`nix-upgrade`) | update flake inputs, switch, `brew upgrade --greedy`, gc |
| `just build` | build without activating |
| `just rollback [gen]` | previous generation, or a specific one |
| `just gc` (`nix-clean`) | delete generations older than 3 days, collect garbage |
| `just check` | formatting, deadnix, statix and a full system build |
| `just fmt` | format nix and lua files |

Homebrew taps are pinned by `flake.lock`, so new cask and formula versions only
arrive with `just update` / `just upgrade`.

## First run on a new Mac

1. Install [Determinate Nix](https://determinate.systems/nix/).
2. Clone this repo to `~/repos/nix` (or change `my.repoDir`).
3. Activate once, before `nh` and `just` exist:

   ```fish
   sudo nix run nix-darwin -- switch --flake .#nebula
   ```

4. Make fish the login shell: `chsh -s ~/.nix-profile/bin/fish`.
