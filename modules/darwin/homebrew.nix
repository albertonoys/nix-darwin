let
  # Helper function to create a cask with default greedy = true
  makeCask = name: {
    inherit name;
    greedy = true;
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
    "pyenv"
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
in {
  casks = map makeCask basicCasks;
  brews = brews;
}
