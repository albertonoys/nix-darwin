{ config, pkgs, ... }:

let user = "noys"; in

{

  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    ../../modules/shared/cachix
  ];

  # Auto upgrade nix package and the daemon service.
  services = {
    nix-daemon.enable = true;
  };

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "${user}" ];
      experimental-features = "nix-command flakes";
    };
  };

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  security.pam.enableSudoTouchIdAuth = true;

  system = {
    stateVersion = 4;
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

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      screencapture.location = "~/Pictures/Screenshots";
      loginwindow.LoginwindowText = "You should not be here.";
      screensaver.askForPasswordDelay = 10;
    };
  };
}
