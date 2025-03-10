# nix-darwin configuration
# https://mynixos.com/nix-darwin/options
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/darwin/home-manager.nix
  ];

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    enable = false;
    # package = pkgs.nix;
    # settings = {
    #   trusted-users = ["@admin" "noys"];
    #   experimental-features = "nix-command flakes";
    # };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };

  environment.systemPackages = with pkgs; (import ../../modules/darwin/packages.nix {inherit pkgs;});

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    stateVersion = 5;
    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        AppleShowAllFiles = true;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        "com.apple.keyboard.fnState" = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.6;
      };

      dock = {
        mru-spaces = false;
        autohide = true;
        autohide-time-modifier = 0.0;
        show-recents = false;
        launchanim = true;
        orientation = "right";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
      };

      # trackpad = {
      #   Clicking = true;
      #   TrackpadThreeFingerDrag = true;
      # };

      screencapture.location = "~/Pictures/Screenshots";
      loginwindow.LoginwindowText = "You should not be here.";
      screensaver.askForPasswordDelay = 10;
    };
    # activationScripts.extraUserActivation.text = lib.mkOrder 1501 (lib.concatStringsSep "\n" (lib.mapAttrsToList (prefix: d:
    #   if d.enable
    #   then ''
    #     # sudo chown -R ${config.nix-homebrew.user} ${prefix}/bin
    #     # sudo chgrp -R ${config.nix-homebrew.group} ${prefix}/bin
    #     sudo chown -R ${config.nix-homebrew.user} ${prefix}
    #     sudo chgrp -R ${config.nix-homebrew.group} ${prefix}
    #   ''
    #   else "")
    # config.nix-homebrew.prefixes));
  };

  programs.fish.enable = true;
  environment.shells = with pkgs; [fish];
  # environment.variables."SSL_CERT_FILE" = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
}
