{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  dockutil
  rectangle
  stats
  raycast
  yt-dlp
  tio
  act
  appcleaner
  python39
  python39Packages.virtualenv
  maccy
]
