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

    flake-utils.url = "github:numtide/flake-utils";

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
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    kitty-icon = {
      url = "github:k0nserv/kitty-icon";
      flake = false;
    };
    # gromgit-fuse = {
    #   url = "github:gromgit/homebrew-fuse";
    #   flake = false;
    # };
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
    flake-utils,
    home-manager,
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    kitty-icon,
    # gromgit-fuse,
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

    mkApp = scriptName: {
      type = "app";
      program = "${
        (nixpkgs.legacyPackages.${system}.writeScriptBin scriptName (
          builtins.readFile ./apps/${scriptName}
        ))
      }/bin/${scriptName}";
    };

    overlays = [
      (final: prev: {
        kitty = prev.kitty.overrideAttrs (oldAttrs: {
          postInstall =
            (oldAttrs.postInstall or "")
            + ''
              mkdir -p $out/Applications/kitty.app/Contents/Resources
              cp -f ${inputs.kitty-icon}/build/neue_outrun.icns $out/Applications/kitty.app/Contents/Resources/kitty.icns
            '';
        });
        # pipx 1.8.0 tests fail due to whitespace formatting in package specifiers
        pipx = prev.pipx.overrideAttrs (old: {
          disabledTests =
            (old.disabledTests or [])
            ++ [
              "test_fix_package_name"
              "test_parse_specifier_for_metadata"
            ];
        });
      })
    ];
  in {
    devShells.${system} = devShell;

    apps.${system} = {
      "apply" = mkApp "apply";
      "build" = mkApp "build";
      "build-switch" = mkApp "build-switch";
      "build-switch-fast" = mkApp "build-switch-fast";
      "rollback" = mkApp "rollback";
    };

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
          nixpkgs.overlays = overlays;
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
              "homebrew/homebrew-bundle" = homebrew-bundle;
              # "gromgit/homebrew-fuse" = gromgit-fuse;
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
