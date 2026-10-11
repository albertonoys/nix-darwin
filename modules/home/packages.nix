{pkgs, ...}: {
  home.packages = with pkgs; [
    # Shell & CLI tools
    delta
    gdu
    gitleaks
    lefthook
    tlrc
    gum
    alejandra
    just
    hyperfine
    pipx
    glow
    aria2
    caddy
    sd
    pv
    rclone
    nh
    tmux

    # GNU utilities (modern versions to replace macOS defaults)
    gnugrep # Modern grep
    gnused # Modern sed
    gawk # Modern awk
    findutils # Modern find, xargs, locate
    gnutar # Modern tar
    gnumake # Modern make
    bash # Modern bash (macOS ships with 3.2 from 2007)
    coreutils # Modern ls, cat, cp, mv, etc.
    diffutils # Modern diff, cmp

    # Additional modern CLI replacements
    dust # Modern du
    procs # Modern ps
    duf # Modern df

    # File & Directory Navigation
    broot # Interactive tree view with fuzzy search
    zellij # Modern tmux alternative (Rust-based)
    navi # Interactive cheatsheet tool

    # System Monitoring & Process Management
    bandwhich # Network bandwidth monitor per process
    gping # Ping with a graph

    # Search & Text Processing
    ast-grep # Structural search/replace for code

    # Git Tools
    gitui # Fast TUI for git (alternative to lazygit)
    onefetch # Git repo summary with stats
    git-cliff # Changelog generator
    gh-dash # GitHub dashboard in terminal
    act

    # Development & Debugging
    nil # Nix language server
    nixd
    hexyl # Beautiful hex viewer
    grex # Generate regex from examples
    tokei # Fast code statistics
    # watchexec # Better file watcher than entr — disabled: cctools ld crash on aarch64-darwin (nixpkgs#regression)
    esphome # ESPHome tool for ESP32/ESP8266
    git-filter-repo

    # Network & HTTP
    xh # Modern curl/httpie alternative (Rust)
    doggo # Modern dig alternative
    trippy # Network traceroute with TUI

    # File Operations
    renameutils # Interactive bulk rename
    ouch # Unified compression tool

    # Misc Productivity
    vivid # LS_COLORS generator
    pastel # Color manipulation tool

    # Hardware/Serial Communication
    minicom # Serial terminal (classic but useful)
    picocom # Lighter serial terminal
    silicon # Create beautiful code screenshots
    mdcat # Render markdown in terminal

    # Embedded & hardware tools
    stlink-tool
    tio

    # Fonts
    meslo-lgs-nf

    # MacOS apps
    appcleaner

    # Android tools
    apktool
    dex2jar
    ghidra
    zulu21

    # Security & pentesting
    dirbuster
    nmap
    ffuf
    gobuster
    drawio
    bws
    yq
    ncdu
  ];
}
