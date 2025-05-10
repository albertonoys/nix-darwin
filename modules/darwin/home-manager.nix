{
  config,
  pkgs,
  lib,
  inputs,
  home-manager,
  name,
  useremail,
  username,
  hostname,
  ...
}: {
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    description = username;
    # shell = pkgs.lib.mkForce "/Users/${username}/.nix-profile/bin/fish";
  };

  nix.settings.trusted-users = [username];

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

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

    users.${username} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      imports = [
        ./programs/shell.nix
        ./programs/fish.nix
        (import ./programs/git.nix {inherit name useremail;})
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
        stateVersion = "24.11";
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

        yazi = {
          enable = true;
          settings = {
            manager = {
              show_hidden = true;
              sort_dir_first = true;
            };
          };
        };

        skim = {
          enable = true;
          enableBashIntegration = true;
        };

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
            "/Users/${username}/.ssh/config_external"
          ];
          matchBlocks = {
            "github.com" = {
              identitiesOnly = true;
              identityFile = [
                "/Users/${username}/.ssh/id_github"
              ];
            };
          };
        };
      };
    };
  };
}
