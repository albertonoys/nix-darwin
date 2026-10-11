# CLI tools from nixpkgs. GUI apps come from Homebrew casks (darwin/homebrew.nix),
# brew formulae only when nixpkgs lacks or breaks a tool on darwin.
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Shell & CLI tools
    gum # Prompts and spinners for shell scripts
    hyperfine # Command benchmarking
    just # Command runner (this repo's Justfile)
    lefthook # Git hooks manager
    nh # Nix helper: switch, clean, diffs
    pv # Pipe progress bar
    sd # sed for find/replace
    tlrc # tldr pages
    tmux # Terminal multiplexer
    topgrade # Upgrade everything at once
    yq # jq for YAML/TOML/XML

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

    # Markdown
    glow # Markdown reader TUI
    mdcat # Render markdown in terminal

    # Network & transfer
    aria2 # Multi-connection downloader
    bandwhich # Bandwidth per process
    caddy # Web server with automatic HTTPS
    doggo # dig
    gping # Ping with a graph
    iperf3 # Bandwidth testing
    rclone # Cloud storage sync
    rsync # Newer than macOS's openrsync
    socat # netcat on steroids
    trippy # Traceroute TUI
    wget
    xh # curl/httpie

    # Media & PDF
    exiftool # Read/write file metadata
    mupdf # mutool, PDF viewer
    pdfcpu # PDF split/merge/optimise
    potrace # Bitmap to vector

    # Git
    act # Run GitHub Actions locally
    gh-dash # GitHub dashboard in terminal
    git-cliff # Changelog generator
    git-filter-repo # Rewrite git history
    gitleaks # Secret scanner (lefthook pre-commit)
    onefetch # Repo summary with stats

    # Development
    alejandra # Nix formatter, used by zed
    ast-grep # Structural search/replace
    biome # JS/TS/JSON formatter, used by zed
    esphome # ESP32/ESP8266
    grex # Regex from examples
    hexyl # Hex viewer
    nil # Nix language server, used by zed
    pastel # Color manipulation
    silicon # Code screenshots
    tokei # Code statistics
    vivid # LS_COLORS generator
    xcodegen # Xcode project from a spec
    # watchexec # disabled: cctools ld crash on aarch64-darwin

    # Hardware & serial
    macmon # Apple Silicon power/temp monitor, no sudo
    minicom # Serial terminal
    picocom # Serial terminal
    stlink-tool # STM32 ST-Link flasher
    tio # Serial terminal

    # Android & reverse engineering
    apktool # Decode/rebuild APKs
    dex2jar # dex to jar
    ghidra # Disassembler/decompiler (no cask)
    zulu21 # JDK, fallback JAVA_HOME (fish.nix)

    # Security
    aircrack-ng # WiFi auditing
    bws # Bitwarden Secrets Manager CLI
    dirbuster # Web path brute forcer (GUI)
    ffuf # Web fuzzer
    gobuster # Dir/DNS/vhost brute forcer
    hashcat # Password recovery
    nmap # Port scanner

    # GUI apps (copied to ~/Applications/Home Manager Apps)
    appcleaner # App uninstaller
    drawio # Diagrams
  ];
}
