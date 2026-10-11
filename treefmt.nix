# `nix fmt` formats; `nix flake check` fails on unformatted files or lint findings.
{
  projectRootFile = "flake.nix";

  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    statix = {
      enable = true;
      # `system.foo = ...; system.bar = ...;` is the usual module style.
      disabled-lints = ["repeated_keys"];
    };
    stylua.enable = true; # nvim config; reads dotfiles/nvim/.stylua.toml
  };
}
