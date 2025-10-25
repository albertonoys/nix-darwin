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
    "calibre"
    "cursor" # Code editor
    "discord"
    "ghostty"
    # "glance-chamburr" # Menu bar hidden bar
    "google-chrome"
    "hiddenbar" # Menu bar hidden bar
    "iina" # Video player
    "jellyfin-media-player"
    "jordanbaird-ice" # Menu bar hidden bar
    "keyclu" # Keyboard shortcuts
    # "kicad" # PCB design
    "legcord" # Discord
    "linearmouse" # Mouse
    "localsend"
    "maccy" # Clipboard manager
    "obsidian"
    "orbstack" # Docker
    "orcaslicer" # 3D slicer (Slic3r)
    "pearcleaner" # Disk cleaner
    "raycast" # Launcher
    "rectangle" # Window manager
    "sonic-pi" # Music
    "stats" # System monitor
    "telegram"
    "todoist-app"
    "upscayl" # Image upscaler
    "zed" # Code editor
    "tempbox"
    "latest"
    "openmtp"
    "mounty"
    "kitty"
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
    "python@3.12"
    "gcc"
    "gfortran"
    "scipy"
    "pyenv"
    "uv"

    # ntfs
    "autoconf"
    "automake"
    "libtool"
    "libgcrypt"
    "pkg-config"
    "gromgit/fuse/ntfs-3g-mac"
  ];
in {
  casks = (map makeCask basicCasks) ++ [(makeCask "middleclick" // specialCasks.middleclick)];
  brews = brews;
}
