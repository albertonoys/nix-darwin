_: let
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
    "latest"
    "kitty"
    "telegram"
    "calibre"
    "openscad@snapshot"

    "openmtp"
    "cursor" # Code editor
    # "antigravity" # Code editor
    "jellyfin-media-player"
    "jordanbaird-ice" # Menu bar hidden bar
    "keyclu" # Keyboard shortcuts
    # "kicad" # PCB design
    "legcord" # Discord
    "orbstack" # Docker
    "orcaslicer" # 3D slicer (Slic3r)
    "sonic-pi" # Music
    "upscayl" # Image upscaler
    "mounty"
    "balenaetcher"
    "ticktick"
    "whatsapp"
    "arduino-ide"
    "cubicsdr"
    "gqrx"
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
    "qemu"

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
    "gemini-cli" # Gemini CLI
    "openai-whisper" # Local speech-to-text with Whisper CLI
    # "sag" # ElevenLabs text-to-speech
  ];
in {
  casks = (map makeCask basicCasks) ++ [(makeCask "middleclick" // specialCasks.middleclick)];
  brews = brews;
}
