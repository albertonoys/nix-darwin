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
    "cursor"
    "linearmouse"
    "raycast"
    "orcaslicer"
    "stats"
    "maccy"
    "jordanbaird-ice"
    "glance-chamburr"
    "pearcleaner"
    "iina"
    "todoist"
    "google-chrome"
    "hiddenbar"
    "obsidian"
    "zed"
    "discord"
    "keyclu"
    "rectangle"
    "visual-studio-code"
    "sonic-pi"
    "kicad"
    "ghostty"
    "synology-drive"
    "calibre"
    "jellyfin-media-player"
    "telegram"
    "wireshark"
    "localsend"
    "legcord"
    "orbstack"
    "upscayl"
  ];

  # List of brews
  brews = [
    "bitwarden-cli"
    "ffmpeg"
    "topgrade"
    "pnpm"
    "wget"
    "curl"
    "aria2"
  ];
in {
  casks = (map makeCask basicCasks) ++ [(makeCask "middleclick" // specialCasks.middleclick)];
  brews = brews;
}
