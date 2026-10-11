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

    fish-tide = {
      url = "github:IlanCosman/tide/v6.1.1";
      flake = false;
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "brew-src";
    };
    # Pinned ahead of nix-homebrew's bundled brew; bump when homebrew-core needs newer DSL
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
    nixpkgs,
    nix-darwin,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  in {
    darwinConfigurations.nebula = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [./hosts/nebula];
    };

    devShells.aarch64-darwin.default = pkgs.mkShell {
      packages = [pkgs.bashInteractive pkgs.git];
    };

    formatter.aarch64-darwin = pkgs.alejandra;
  };
}
