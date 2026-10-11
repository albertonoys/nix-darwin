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
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    deskflow-tap,
    thatsjustcheesy-tap,
    lab421-tap,
    tinycast-tap,
    ...
  }: let
    system = "aarch64-darwin";
    username = "noys";
    name = "Alberto Noys";
    useremail = "albertonoys@gmail.com";
    hostname = "nebula";

    devShell = let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = with pkgs;
        mkShell {
          nativeBuildInputs = with pkgs; [
            bashInteractive
            git
          ];
          shellHook = "";
        };
    };
  in {
    devShells.${system} = devShell;

    darwinConfigurations.nebula = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs =
        inputs
        // {
          inherit
            username
            hostname
            name
            useremail
            ;
        };
      modules = [
        home-manager.darwinModules.home-manager
        {
          nixpkgs.config.allowUnfree = true;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;
            group = "admin";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "deskflow/homebrew-tap" = deskflow-tap;
              "thatsjustcheesy/homebrew-tap" = thatsjustcheesy-tap;
              "lab421/homebrew-tap" = lab421-tap;
              "abue-ammar/homebrew-tinycast" = tinycast-tap;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
        ./hosts/darwin
      ];
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
