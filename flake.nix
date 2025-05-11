{
  description = "Nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nix-darwin.url = "github:LnL7/nix-darwin/master";
    # nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager = {
    #   url = "github:nix-community/home-manager/master";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    flake-utils.url = "github:numtide/flake-utils";

    fish-tide = {
      url = "github:IlanCosman/tide/v6.1.1";
      flake = false;
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew/4945f477bc346d6cd432c67642621f33e6a9b201";
      inputs.nixpkgs.follows = "nixpkgs";
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
          nativeBuildInputs = with pkgs; [bashInteractive git];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
    };

    mkApp = scriptName: {
      type = "app";
      program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
        #!/usr/bin/env bash
        PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
        echo "Running ${scriptName} for ${system}"
        exec ${self}/apps/${scriptName}
      '')}/bin/${scriptName}";
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
      })
    ];

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = overlays;
    };
  in {
    devShells.${system} = devShell;

    apps.${system} = {
      "apply" = mkApp "apply";
      "build" = mkApp "build";
      "build-switch" = mkApp "build-switch";
      "copy-keys" = mkApp "copy-keys";
      "create-keys" = mkApp "create-keys";
      "check-keys" = mkApp "check-keys";
      "rollback" = mkApp "rollback";
    };

    darwinConfigurations.${system} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = inputs // {inherit pkgs username hostname name useremail;};
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
              "homebrew/homebrew-bundle" = homebrew-bundle;
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
