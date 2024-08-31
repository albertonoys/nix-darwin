{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  rectangle
  stats
  yt-dlp
  tio
  act
  appcleaner
  python39
  python39Packages.virtualenv
  maccy
  stats
  skhd
]
