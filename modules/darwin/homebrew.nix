let
  # Helper function to create a cask with default greedy = true
  makeCask = name: {
    inherit name;
    greedy = true;
  };

  # Special cases with additional arguments
  specialCasks = {
    middleclick = {args = {no_quarantine = false;};};
  };

  # List of simple cask names
  basicCasks = [
    # Essentials
    "ghostty"
    "discord"
    "google-chrome"
    "iina" # Video player
    "linearmouse" # Mouse
    "localsend"
    "maccy" # Clipboard manager
    "obsidian"
    "pearcleaner" # Disk cleaner
    "raycast" # Launcher
    "rectangle" # Window manager
    "stats" # System monitor
    "todoist-app"
    "zed" # Code editor
    "tempbox"
    "kitty"
    "telegram"
    "calibre"
    "openscad@snapshot"

    "android-studio"
    "openmtp"
    "cursor" # Code editor
    # "antigravity" # Code editor
    "jellyfin-media-player"
    "jordanbaird-ice" # Menu bar hidden bar
    "keyclu" # Keyboard shortcuts
    # "kicad" # PCB design
    #"orbstack" # Docker
    "orcaslicer" # 3D slicer (Slic3r)
    "sonic-pi" # Music
    "mounty"
    "balenaetcher"
    "ticktick"
    "whatsapp"
    "arduino-ide"
    #"cubicsdr"
    #"gqrx"
    "brave-browser"
  ];

  # List of brews
  brews = [
    # Media & downloads
    "ffmpeg"
    "wget"
    "curl"
    "imagemagick"
    "dump1090-mutability"

    # System tools
    "topgrade"
    "rsync"
    "grsync"
    "iperf3"
    "socat"

    # Development
    "node@22"
    "pnpm"
    "docker"
    "gcc"
    "gfortran"
    "scipy"
    "pyenv"
    "uv"

    # Security & network
    "bettercap"
    "hashcat"
    "hcxtools"
    "aircrack-ng"
    #"qemu"

    # Hardware/embedded (better in brew)
    "esphome"

    # PDF tools
    "ghostscript"
    "pdfcpu"
    "qpdf"
    "mupdf"
    "exiftool"
    "poppler"
    "ocrmypdf"

    # Other utilities
    "taskell"
    "fx-upscale"
    "libxmp"
    "libxmp-lite"
    "llama.cpp"

    # OpenClaw & AI tools
    #"gemini-cli" # Gemini CLI
    "openai-whisper" # Local speech-to-text with Whisper CLI
    # "sag" # ElevenLabs text-to-speech
    "worktrunk"
    "lsusb"
  ];
in {
  casks = (map makeCask basicCasks) ++ [(makeCask "middleclick" // specialCasks.middleclick)];
  brews = brews;
}
