{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  ...
}: let
  user = "noys";
  name = "Alberto Noys";
  email = "albertonoys@gmail.com";
in {
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.lib.mkForce "/Users/${user}/.nix-profile/bin/fish";
  };

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    global.brewfile = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    casks = (pkgs.callPackage ./homebrew.nix {}).casks;
    brews = (pkgs.callPackage ./homebrew.nix {}).brews;
    masApps = {
      "WhatsApp Messenger" = 310633997;
      "TickTick:To-Do List, Calendar" = 966085870;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "nixbckp";

    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      imports = [
        ./programs/fish.nix
        (import ./programs/git.nix {inherit name email;})
        ./programs/vim.nix
        ./programs/zsh.nix
      ];
      home = {
        packages = pkgs.callPackage ./packages.nix {};
        file.".config" = {
          source = ../../dotfiles;
          recursive = true;
          executable = true;
        };
        stateVersion = "24.05";
      };
      programs = {
        bat.enable = true;
        bottom.enable = true;
        btop.enable = true;
        bun.enable = true;
        direnv.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        fd.enable = true;
        fzf.enable = true;
        gh.enable = true;
        home-manager.enable = true;
        jq.enable = true;
        lazygit.enable = true;
        neovim.enable = true;
        ripgrep.enable = true;
        zoxide.enable = true;

        atuin = {
          enable = true;
          settings = {
            dialect = "uk";
            style = "compact";
            inline_height = 20;
            show_preview = true;
            enter_accept = true;
            sync.records = true;
            dotfiles.enabled = false;
          };
        };

        ssh = {
          enable = true;
          includes = [
            "/Users/${user}/.ssh/config_external"
          ];
          matchBlocks = {
            "github.com" = {
              identitiesOnly = true;
              identityFile = [
                "/Users/${user}/.ssh/id_github"
              ];
            };
          };
        };
      };
    };
  };
}
