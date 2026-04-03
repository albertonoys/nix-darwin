{
  config,
  pkgs,
  fish-tide,
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
    shell = pkgs.lib.mkForce "/Users/${username}/.nix-profile/bin/fish";
  };

  nix.settings.trusted-users = [username];

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    global.brewfile = true;
    prefix = "/opt/homebrew";
    onActivation = {
      cleanup = "zap";
      autoUpdate = builtins.getEnv "HOMEBREW_UPDATE" == "1";
      upgrade = builtins.getEnv "HOMEBREW_UPGRADE" == "1";
    };
    casks = (import ./homebrew.nix).casks;
    brews = (import ./homebrew.nix).brews;
    # masApps = {};
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "nixbckp";
    extraSpecialArgs = {inherit fish-tide;};

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
        stateVersion = "26.05";
        activation.dotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
          find "${config.home.homeDirectory}/repos/nix/dotfiles" -type f | while read -r src; do
            rel="''${src#${config.home.homeDirectory}/repos/nix/dotfiles/}"
            dest="${config.home.homeDirectory}/.config/''${rel}"
            mkdir -p "$(dirname "$dest")"
            ln -sf "$src" "$dest"
          done
        '';
      };
      programs = {
        bat.enable = true;
        bun.enable = true;
        codex.enable = true;
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
        man.generateCaches = false;

        btop.enable = true;

        yazi = {
          enable = true;
          settings = {
            manager = {
              show_hidden = true;
              sort_dir_first = true;
            };
          };
        };

        atuin.enable = true;
      };
    };
  };
}
