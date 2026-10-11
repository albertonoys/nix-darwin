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
    # Browsers
    "brave-browser"
    "google-chrome"

    # Chat
    "beeper" # Matrix-bridged inbox for every chat app
    "discord"
    "telegram"
    "whatsapp"

    # Terminals & editors
    "ghostty" # Terminal
    "kitty" # Terminal
    "markedit" # Markdown editor
    "obsidian" # Notes
    "zed" # Code editor

    # Development
    "agentsview" # Browse past AI coding sessions
    "android-studio" # Also provides adb/fastboot via its SDK (on PATH in fish/zsh)
    "antigravity" # Agent orchestration
    "antigravity-cli" # Terminal client for antigravity
    "antigravity-ide" # Agent IDE
    "docker-desktop"

    # Tasks & productivity
    "handy" # Speech to text
    "ticktick" # Tasks
    "todoist-app" # Tasks

    # Window, keyboard & mouse
    "hyperkey" # Caps Lock as hyper key
    "karabiner-elements" # Keyboard remapping
    "linearmouse" # Mouse acceleration/scroll
    "middleclick" # Trackpad middle click
    "raycast" # Launcher
    "rectangle" # Window manager
    "abue-ammar/tinycast/tinycast" # Launcher, hotkeys, clipboard history

    # System utilities
    "clop" # Image/video/clipboard optimiser
    "thatsjustcheesy/tap/defaults-edit" # GUI for `defaults`
    "lab421/tap/forel" # Folder-watching file automation
    "latest" # Shows available app updates
    "maccy" # Clipboard manager
    "macpacker" # Archive manager
    "macusb" # Bootable USB installer maker
    "puremac" # App uninstaller and cleaner
    "shottr" # Screenshot tool with blur/pixelate
    "vorssaint" # Menu bar keep-awake, monitor, volume mixer

    # Files & sharing
    "blip" # Send files between devices
    "deskflow/tap/deskflow" # Keyboard/mouse sharing
    "localsend" # AirDrop alternative
    "openmtp" # Android file transfer

    # Media & 3D
    "bambu-studio" # 3D slicer
    "iina" # Video player
    "openscad@snapshot" # Programmable 3D CAD
    "rawtherapee" # RAW photo editor
    "sonic-pi" # Live-coded music
  ];

  # CLI tools that nixpkgs lacks or breaks on darwin, that other brews already
  # pull in, or that move fast enough to want brew's bottles. Everything else
  # goes in modules/home/packages.nix.
  brews = [
    # Media
    "ffmpeg" # Also needed by whisper and ocrmypdf
    "fx-upscale" # Metal video upscaling (not in nixpkgs)
    "imagemagick"
    "libxmp" # Module music (MOD/S3M/IT) library
    "libxmp-lite"

    # PDF
    "ghostscript"
    "ocrmypdf" # Add an OCR text layer to scanned PDFs
    "poppler" # pdftotext, pdfimages, ...
    "qpdf"

    # Development
    "cocoapods" # iOS dependency manager
    "node"
    "pnpm"
    "uv" # Python, venvs and tools

    # AI
    "llama.cpp" # Local LLM inference
    "openai-whisper" # Local speech-to-text
    "opencode" # Terminal coding agent
    "rtk" # Token-saving CLI output proxy for agents
    "worktrunk" # Git worktrees for parallel agents

    # Security
    "bettercap" # Network attack/monitoring (broken in nixpkgs)
    "hcxtools" # WiFi capture conversion (linux-only in nixpkgs)

    # Android & reverse engineering
    "jadx" # Dex to Java decompiler (nixpkgs drags in a python stack)
    "vineflower" # Java decompiler (not in nixpkgs)

    # System & utilities
    "bitwarden-cli" # bw
    "grsync" # rsync GUI
    "lsusb" # List USB devices
    "mole" # Mac cleanup (broken in nixpkgs)
    "taskell" # Kanban board TUI (not in nixpkgs)
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
