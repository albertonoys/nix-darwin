_: let
  # Helper function to create a cask with default greedy = true
  makeCask = name: { inherit name; greedy = true; };

  # Special cases with additional arguments
  specialCasks = {
    middleclick = { args = { no_quarantine = true; }; };
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
    "rambox"
    "docker"
    "kicad"
  ];
in
# Convert basic casks to full config and combine with special cases
(map makeCask basicCasks) ++ [
  (makeCask "middleclick" // specialCasks.middleclick)
]
