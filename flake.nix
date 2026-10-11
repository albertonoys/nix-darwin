{
  description = "Nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "brew-src";
    };
    # Pinned ahead of nix-homebrew's bundled brew (7.0.4 as of 2026-10), which is
    # too old for current homebrew-core. Drop this input (and the follows above)
    # once nix-homebrew bundles a brew at least this new.
    brew-src = {
      url = "github:Homebrew/brew/7.0.9";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    deskflow-tap = {
      url = "github:deskflow/homebrew-tap";
      flake = false;
    };
    thatsjustcheesy-tap = {
      url = "github:thatsjustcheesy/homebrew-tap";
      flake = false;
    };
    lab421-tap = {
      url = "github:lab421/homebrew-tap";
      flake = false;
    };
    tinycast-tap = {
      url = "github:abue-ammar/homebrew-tinycast";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    treefmt-nix,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
  in {
    darwinConfigurations.nebula = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [./hosts/nebula];
    };

    formatter.aarch64-darwin = treefmt.config.build.wrapper;

    checks.aarch64-darwin = {
      formatting = treefmt.config.build.check self;
      darwin = self.darwinConfigurations.nebula.system;
    };

    devShells.aarch64-darwin.default = pkgs.mkShell {
      packages = [treefmt.config.build.wrapper pkgs.just pkgs.nh];
    };
  };
}
