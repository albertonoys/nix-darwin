# nix-darwin configuration
# https://mynixos.com/nix-darwin/options
{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/darwin/home-manager.nix
  ];

  # Determinate Nix manages the daemon and /etc/nix/nix.conf, so nix-darwin's
  # nix module must stay off (and `nix.settings` would be ignored). Extra
  # settings go in nix.custom.conf, which nix.conf `!include`s.
  nix.enable = false;
  environment.etc."nix/nix.custom.conf" = {
    text = ''
      trusted-users = root ${username}
      download-buffer-size = 1073741824
    '';
    # Hash of the stub the Determinate installer writes, so nix-darwin can take it over.
    knownSha256Hashes = ["3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa"];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Passwordless sudo only for what `darwin-rebuild switch` shells out to, so
  # rebuilds work unattended (e.g. docked with the lid closed, no Touch ID).
  # Homebrew cask upgrades that ship .pkg installers need installer/pkgutil. If
  # a cask still prompts, find the binary next to its `Upgrading <cask>` line
  # and add it here.
  security.sudo.extraConfig = ''
    ${username} ALL=(ALL) NOPASSWD: /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings
    ${username} ALL=(ALL) NOPASSWD: /usr/sbin/installer
    ${username} ALL=(ALL) NOPASSWD: /usr/bin/pkgutil
  '';

  system = {
    stateVersion = 5;
    primaryUser = username;
    checks.verifyNixPath = false;
    activationScripts.extraActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      sudo -u $primaryUser /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true;
      NSGlobalDomain = {
        # Delay before a held key starts repeating.
        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 3; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)
        AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
        ApplePressAndHoldEnabled = true; # holding a letter shows the accent picker instead of repeating it
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
        autohide-delay = 0.0;
        autohide-time-modifier = 0.4;
        show-recents = false;
        launchanim = true;
        orientation = "right";
        tilesize = 48;

        wvous-tl-corner = 2; # top-left - Mission Control
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

      loginwindow = {
        LoginwindowText = "You should not be here.";
        GuestEnabled = false;
      };

      screencapture = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };

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
          "spans-displays" = 0; # displays have separate spaces
        };
        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = 0; # clicking the wallpaper does not reveal the desktop
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
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        # Prevent Photos from opening automatically when devices are plugged in
        "com.apple.ImageCapture".disableHotPlug = true;
      };
    };
  };

  documentation.enable = false;

  programs.fish.enable = true;
  environment.variables.EDITOR = "nvim";
  environment.shells = [
    "/Users/${username}/.nix-profile/bin/fish"
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
    ];
  };
}
