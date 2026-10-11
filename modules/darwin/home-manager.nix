{
  config,
  pkgs,
  fish-tide,
  name,
  useremail,
  username,
  hostname,
  ...
} @ args: {
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    description = username;
    shell = pkgs.lib.mkForce "/Users/${username}/.nix-profile/bin/fish";
  };

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    global.brewfile = false;
    prefix = "/opt/homebrew";
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      # autoUpdate = builtins.getEnv "HOMEBREW_UPDATE" != "0";
      upgrade = true;
      # upgrade = builtins.getEnv "HOMEBREW_UPGRADE" != "0";
    };
    casks = (import ./homebrew.nix).casks;
    brews = (import ./homebrew.nix).brews;
    # masApps = {};
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  # `brew bundle --upgrade` only upgrades formulae listed in the Brewfile, so
  # dependencies that got a new version/revision on their own are left behind.
  # Runs after the homebrew activation step; casks are handled by bundle (greedy).
  system.activationScripts.postActivation.text = pkgs.lib.mkIf config.homebrew.onActivation.upgrade ''
    echo >&2 "Homebrew upgrade (dependencies)..."
    if [ -x "${config.homebrew.prefix}/bin/brew" ]; then
      PATH="${config.homebrew.prefix}/bin:$PATH" sudo --preserve-env=PATH --user=${username} --set-home \
        env HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade --formula || true
    fi
  '';

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
            case "$rel" in nvim/*) continue ;; esac
            dest="${config.home.homeDirectory}/.config/''${rel}"
            mkdir -p "$(dirname "$dest")"
            [ "$(readlink "$dest" 2>/dev/null)" = "$src" ] && continue
            ln -sf "$src" "$dest"
          done
        '';

        activation.stripCaskQuarantine = lib.hm.dag.entryAfter ["writeBoundary"] ''
          echo "Stripping quarantine flags from apps updated during this rebuild..."
          # Finds apps in /Applications modified within the last 15 minutes and strips quarantine attribute
          find /Applications -maxdepth 2 -name "*.app" -mmin -15 -print0 2>/dev/null | xargs -0 xattr -r -d com.apple.quarantine 2>/dev/null || true
        '';
      };
      xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/nix/dotfiles/nvim/init.lua";
      programs = {
        bat.enable = true;
        bun.enable = true;
        codex.enable = false;
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
      };
    };
  };
}
