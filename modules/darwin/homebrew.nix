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
    "ghostty"
    "discord"
    "google-chrome"
    "iina" # Video player
    "linearmouse" # Mouse
    "localsend"
    "maccy" # Clipboard manager
    "obsidian"
    "shottr" # Screenshot tool with blur/pixelate
    "raycast" # Launcher
    "rectangle" # Window manager
    "todoist-app"
    "zed" # Code editor
    "kitty"
    "telegram"
    "openscad@snapshot"
    "bambu-studio" # 3D slicer

    "android-studio"
    "openmtp"
    "sonic-pi" # Music
    "ticktick"
    "whatsapp"
    "brave-browser"
    "hyperkey"
    "latest"
    "blip"
    "karabiner-elements"
    "deskflow/tap/deskflow" # Keyboard/mouse sharing
    "puremac"
    "antigravity"
    "antigravity-cli"
    "antigravity-ide"
    "vorssaint"
    "beeper"
    "rawtherapee"
    "markedit"
    "thatsjustcheesy/tap/defaults-edit"
    "lab421/tap/forel"
    "agentsview"
    "macpacker"
    "macusb"
    "handy"
    "clop"
    "abue-ammar/tinycast/tinycast"
    "android-platform-tools"
    "middleclick"
  ];

  # CLI tools
  brews = [
    # Media & downloads
    "ffmpeg"
    "wget"
    "imagemagick"

    # System tools
    "topgrade"
    "rsync"
    "grsync"
    "iperf3"
    "socat"

    # Development
    "node"
    "pnpm"
    "docker"
    "gcc"
    "gfortran"
    "scipy"
    "uv"
    "cocoapods"

    # Security & network
    "bettercap"
    "hashcat"
    "hcxtools"
    "aircrack-ng"

    # PDF tools
    "ghostscript"
    "pdfcpu"
    "qpdf"
    "mupdf"
    "exiftool"
    "poppler"
    "ocrmypdf"
    "potrace"

    # Other utilities
    "taskell"
    "fx-upscale"
    "libxmp"
    "libxmp-lite"
    "llama.cpp"
    "bitwarden-cli"
    # OpenClaw & AI tools
    "openai-whisper" # Local speech-to-text with Whisper CLI
    "worktrunk"
    "lsusb"
    "xcodegen"
    "rtk"
    "mole"
    "macmon"
    "opencode"
    "vineflower"
    "jadx"
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
    # (mutableTaps = false), so upgrades happen explicitly via `just nix::upgrade`.
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
