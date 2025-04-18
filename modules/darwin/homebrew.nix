_: let
  # Helper function to create a cask with default greedy = true
  makeCask = name: {
    inherit name;
    greedy = true;
  };

  # Special cases with additional arguments
  specialCasks = {
    middleclick = {args = {no_quarantine = true;};};
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
    "docker"
    "kicad"
    "ghostty"
    "synology-drive"
    "calibre"
  ];

  # List of brews
  brews = [
    "bitwarden-cli"
    "ffmpeg"
    "topgrade"
    "pnpm"
  ];
in {
  casks = (map makeCask basicCasks) ++ [(makeCask "middleclick" // specialCasks.middleclick)];
  brews = brews;
}
