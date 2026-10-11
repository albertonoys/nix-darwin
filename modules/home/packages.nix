# CLI tools from nixpkgs. GUI apps come from Homebrew casks (darwin/homebrew.nix),
# brew formulae only when nixpkgs lacks or breaks a tool on darwin.
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Shell & CLI tools
    aria2
    caddy
    glow # Markdown reader TUI
    gum
    hyperfine
    just
    lefthook
    mdcat # Render markdown in terminal
    nh
    pipx
    pv
    rclone
    sd
    tlrc
    tmux
    yq

    # GNU utilities (modern versions to replace macOS defaults)
    bash # macOS ships 3.2 from 2007
    coreutils
    diffutils
    findutils
    gawk
    gnugrep
    gnumake
    gnused
    gnutar

    # Modern replacements
    duf # df
    dust # du
    gdu # du TUI
    ncdu # du TUI
    procs # ps

    # Files & navigation
    broot # Interactive tree view with fuzzy search
    navi # Interactive cheatsheet tool
    ouch # Unified compression tool
    renameutils # Interactive bulk rename

    # Network
    bandwhich # Bandwidth per process
    doggo # dig
    gping # Ping with a graph
    trippy # Traceroute TUI
    xh # curl/httpie

    # Git
    act # Run GitHub Actions locally
    gh-dash # GitHub dashboard in terminal
    git-cliff # Changelog generator
    git-filter-repo
    gitleaks
    onefetch # Repo summary with stats

    # Development
    alejandra
    ast-grep # Structural search/replace
    biome # JS/TS/JSON formatter, used by zed
    esphome # ESP32/ESP8266
    grex # Regex from examples
    hexyl # Hex viewer
    nil # Nix language server
    nixd # Nix language server
    pastel # Color manipulation
    silicon # Code screenshots
    tokei # Code statistics
    vivid # LS_COLORS generator
    # watchexec # disabled: cctools ld crash on aarch64-darwin

    # Hardware & serial
    minicom
    picocom
    stlink-tool
    tio

    # Android & reverse engineering
    apktool
    dex2jar
    ghidra
    zulu21

    # Security
    bws # Bitwarden Secrets Manager CLI
    dirbuster
    ffuf
    gobuster
    nmap

    # GUI apps that are not casks
    appcleaner
    drawio
  ];
}
