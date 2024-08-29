{ pkgs }:

with pkgs; [
  # General packages for development and system management
  fish
  kitty
  eza
  fd
  ripgrep
  fzf
  bat
  btop
  zoxide
  lazygit
  ncdu
  tlrc
  gum
  jq
  neofetch
  gdu
  gh
  thefuck
  delta
  neovim
  # zsh-autosuggestions
  # zsh-syntax-highlighting

  discord
  vscode
  mpv

  meslo-lgs-nf
  jetbrains-mono
  tmux
  zsh-powerlevel10k

  # coreutils
  # killall

  # openssh
  # sqlite
  # wget
  # zip

  # # Encryption and security tools
  # age
  # age-plugin-yubikey
  # gnupg
  # libfido2

  # # Cloud-related tools and SDKs
  # docker
  # docker-compose

  # # Media-related packages
  # emacs-all-the-icons-fonts
  # dejavu_fonts
  # ffmpeg
  # font-awesome
  # hack-font
  # noto-fonts
  # noto-fonts-emoji




  # # Text and terminal utilities
  # htop
  # hunspell
  # iftop
  # unrar
  # unzip

  # # Python packages
  # python39
  # python39Packages.virtualenv # globally install virtualenv
]
