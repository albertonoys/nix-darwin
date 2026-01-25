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
  ];

  # List of brews
  brews = [
    "ffmpeg"
    "topgrade"
    "pnpm"
    "wget"
    "curl"
    "aria2"
    "bettercap"
    "imagemagick"
    "taskell"
    "ocrmypdf"
    "llama.cpp"
    "esphome"
    "fx-upscale"
    "libxmp"
    "libxmp-lite"

    # pdf squeeze deps
    "ghostscript"
    "pdfcpu"
    "qpdf"
    "mupdf"
    "exiftool"
    "poppler"
    "coreutils"
    "iperf3"
    "socat"
    "docker"
    "gcc"
    "gfortran"
    "scipy"
    "pyenv"
    "uv"
    "hashcat"
    "hcxtools"
  ];
in {
  casks = (map makeCask basicCasks) ++ [(makeCask "middleclick" // specialCasks.middleclick)];
  brews = brews;
}
