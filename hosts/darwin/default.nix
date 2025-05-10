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
      experimental-features = "nix-command flakes";
      auto-optimise-store = false;
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
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true;
      NSGlobalDomain = {
        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # This is very useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 3; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)
        AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
        ApplePressAndHoldEnabled = true; # enable press and hold
        "com.apple.swipescrolldirection" = true;
        "com.apple.keyboard.fnState" = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.6;

        NSAutomaticCapitalizationEnabled = false; # disable auto capitalization
        NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution
        NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution
        NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution
        NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction
        NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      dock = {
        mru-spaces = false;
        autohide = true;
        autohide-time-modifier = 0.0;
        show-recents = false;
        launchanim = true;
        orientation = "right";
        tilesize = 48;

        wvous-tl-corner = 2; # top-left - Mission Control
        # wvous-tr-corner = 13; # top-right - Lock Screen
        wvous-bl-corner = 2; # bottom-left - Mission Control
        wvous-br-corner = 3; # bottom-right - Application Windows
      };

      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        QuitMenuItem = true;
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      # trackpad = {
      #   Clicking = true;
      #   TrackpadRightClick = true;
      #   TrackpadThreeFingerDrag = true;
      # };

      loginwindow = {
        LoginwindowText = "You should not be here.";
        GuestEnabled = false;
      };

      screencapture.location = "~/Pictures/Screenshots";

      CustomUserPreferences = {
        ".GlobalPreferences" = {
          # automatically switch to a new space when switching to the application
          AppleSpacesSwitchOnActivate = true;
        };
        NSGlobalDomain = {
          # Add a context menu item for showing the Web Inspector in web views
          WebKitDeveloperExtras = true;
        };
        "com.apple.finder" = {
          # Open folders in new tabs instead of new windows
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.spaces" = {
          "spans-displays" = 0; # Display have seperate spaces
        };
        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
          StandardHideDesktopIcons = 0; # Show items on desktop
          HideDesktop = 0; # Do not hide items on desktop & stage manager
          StageManagerHideWidgets = 0;
          StandardHideWidgets = 0;
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.screencapture" = {
          location = "~/Pictures/Screenshots";
          type = "png";
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        # Prevent Photos from opening automatically when devices are plugged in
        "com.apple.ImageCapture".disableHotPlug = true;
      };
    };
  };

  programs.fish.enable = true;
  environment.variables.EDITOR = "nvim";
  environment.shells = [
    pkgs.fish
  ];
  # environment.shells = with pkgs; [
  #   "${fish}/bin/fish"
  #   "/run/current-system/sw/bin/fish"
  #   "/Users/noys/.nix-profile/bin/fish"
  # ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];
  };
}
