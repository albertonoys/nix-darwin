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

  # Setup user, packages, programs
  nix = {
    enable = false;
    package = pkgs.nix;
    settings = {
      trusted-users = ["@admin" "noys"];
      experimental-features = "nix-command flakes";
    };
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
  # security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 5;
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
  };

  programs.fish.enable = true;
  environment.shells = with pkgs; [
    "${fish}/bin/fish"
    "/run/current-system/sw/bin/fish"
    "/Users/noys/.nix-profile/bin/fish"
  ];
}
