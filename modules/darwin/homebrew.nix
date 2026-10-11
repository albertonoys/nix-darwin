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

  # GUI apps
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
    "pearcleaner" # Disk cleaner (unmaintained; using self-built PureMac instead)
    "shottr" # Screenshot tool with blur/pixelate
    "raycast" # Launcher
    "rectangle" # Window manager
    #"stats" # System monitor
    "todoist-app"
    "zed" # Code editor
    "tempbox"
    "kitty"
    "telegram"
    # "calibre"
    "openscad@snapshot"
    "bambu-studio" # 3D slicer

    "android-studio"
    # "flutter"
    "openmtp"
    # "cursor" # Code editor
    # "jellyfin-media-player"
    # "jordanbaird-ice" # Menu bar hidden bar
    # "keyclu" # Keyboard shortcuts
    # "kicad" # PCB design
    # "orbstack" # Docker
    # "orcaslicer" # 3D slicer (Slic3r)
    "sonic-pi" # Music
    # "mounty"
    # "balenaetcher"
    "ticktick"
    "whatsapp"
    # "arduino-ide"
    #"cubicsdr"
    #"gqrx"
    "brave-browser"
    "hyperkey"
    "latest"
    # "gimp"
    "blip"
    "karabiner-elements"
    # "zenmap"
    # "angry-ip-scanner"
    "deskflow/tap/deskflow" # Keyboard/mouse sharing
    "puremac"
    # "webtorrent"
    "antigravity"
    "antigravity-cli"
    "antigravity-ide"
    "vorssaint"
    "beeper"
    "rawtherapee"
    # "upscayl"
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
  ];

  # CLI tools
  brews = [
    # Media & downloads
    "ffmpeg"
    "wget"
    "curl"
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
    "pyenv"
    "uv"
    "cocoapods"

    # Security & network
    "bettercap"
    "hashcat"
    "hcxtools"
    "aircrack-ng"
    #"qemu"

    # Hardware/embedded (better in brew)
    # "esphome"

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
    # "gemini-cli" # Gemini CLI
    "openai-whisper" # Local speech-to-text with Whisper CLI
    # "sag" # ElevenLabs text-to-speech
    "worktrunk"
    "lsusb"
    "xcodegen"
    "rtk"
    "mole"
    "macmon"
    "llama.cpp"
    "opencode"
    "vineflower"
    # "openjdk@17"
    "jadx"
  ];
in {
  casks = (map makeCask basicCasks) ++ [(makeCask "middleclick" // specialCasks.middleclick)];
  brews = brews;
}
