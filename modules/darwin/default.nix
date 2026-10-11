# System-level (nix-darwin) modules. Host files import this and set identity.
# https://nix-darwin.github.io/nix-darwin/manual/
{
  imports = [
    ./defaults.nix
    ./fonts.nix
    ./home-manager.nix
    ./homebrew.nix
    ./nix.nix
    ./security.nix
    ./system.nix
  ];
}
