{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  user = config.system.primaryUser;
  prefix = config.homebrew.prefix;

  # GUI apps
  casks = [
    # Essentials
    "bambu-studio" # 3D slicer
    "discord"
    "ghostty"
    "google-chrome"
    "iina" # Video player
    "kitty"
    "linearmouse" # Mouse
    "localsend"
    "maccy" # Clipboard manager
    "obsidian"
    "openscad@snapshot"
    "raycast" # Launcher
    "rectangle" # Window manager
    "shottr" # Screenshot tool with blur/pixelate
    "telegram"
    "todoist-app"
    "zed" # Code editor

    # Everything else
    "agentsview"
    "android-platform-tools"
    "android-studio"
    "antigravity"
    "antigravity-cli"
    "antigravity-ide"
    "beeper"
    "blip"
    "brave-browser"
    "clop"
    "thatsjustcheesy/tap/defaults-edit"
    "deskflow/tap/deskflow" # Keyboard/mouse sharing
    "lab421/tap/forel"
    "handy"
    "hyperkey"
    "karabiner-elements"
    "latest"
    "macpacker"
    "macusb"
    "markedit"
    "middleclick"
    "openmtp"
    "puremac"
    "rawtherapee"
    "sonic-pi" # Music
    "ticktick"
    "abue-ammar/tinycast/tinycast"
    "vorssaint"
    "whatsapp"
  ];

  # CLI tools
  brews = [
    # Media
    "ffmpeg"
    "fx-upscale"
    "imagemagick"
    "libxmp"
    "libxmp-lite"

    # Network & sync
    "grsync"
    "iperf3"
    "rsync"
    "socat"
    "wget"

    # Development
    "cocoapods"
    "docker"
    "gcc"
    "gfortran"
    "node"
    "pnpm"
    "scipy"
    "uv"
    "xcodegen"

    # Security & network
    "aircrack-ng"
    "bettercap"
    "hashcat"
    "hcxtools"

    # PDF tools
    "exiftool"
    "ghostscript"
    "mupdf"
    "ocrmypdf"
    "pdfcpu"
    "poppler"
    "potrace"
    "qpdf"

    # Android & reverse engineering
    "jadx"
    "vineflower"

    # AI
    "llama.cpp"
    "openai-whisper" # Local speech-to-text
    "opencode"
    "rtk"

    # System & utilities
    "bitwarden-cli"
    "lsusb"
    "macmon"
    "mole"
    "taskell"
    "topgrade"
    "worktrunk"
  ];

  # Run brew as the primary user, the same way nix-darwin's bundle step does.
  brew = "PATH=${prefix}/bin:$PATH sudo --preserve-env=PATH --user=${user} --set-home env HOMEBREW_NO_AUTO_UPDATE=1 ${prefix}/bin/brew";
in {
  imports = [inputs.nix-homebrew.darwinModules.nix-homebrew];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    inherit user;
    group = "admin";
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "deskflow/homebrew-tap" = inputs.deskflow-tap;
      "thatsjustcheesy/homebrew-tap" = inputs.thatsjustcheesy-tap;
      "lab421/homebrew-tap" = inputs.lab421-tap;
      "abue-ammar/homebrew-tinycast" = inputs.tinycast-tap;
    };
    mutableTaps = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    global.autoUpdate = false;
    global.brewfile = false;
    prefix = "/opt/homebrew";
    # Activation only installs and removes. Taps are pinned by flake.lock
    # (mutableTaps = false), so upgrades happen explicitly via `just upgrade`.
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = false;
      upgrade = false;
    };
    casks =
      map (name: {
        inherit name;
        greedy = true;
      })
      casks;
    inherit brews;
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  # Strip the quarantine flag from apps installed by the casks above (and only
  # those), so they open without a Gatekeeper prompt. Runs after brew bundle.
  system.activationScripts.postActivation.text = ''
    echo >&2 "Stripping quarantine from cask apps..."
    ${brew} info --json=v2 --cask ${lib.escapeShellArgs casks} 2>/dev/null \
      | ${lib.getExe pkgs.jq} -r '.casks[].artifacts[] | select(.app) | .app[] | if type == "object" then .target else . end' \
      | while IFS= read -r app; do
          case "$app" in /*) path="$app" ;; *) path="/Applications/$app" ;; esac
          if [ -d "$path" ] && xattr -p com.apple.quarantine "$path" >/dev/null 2>&1; then
            xattr -dr com.apple.quarantine "$path" || true
          fi
        done
  '';
}
