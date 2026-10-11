{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ../../../dotfiles/zsh;
        file = "p10k.zsh";
      }
    ];

    # Backup shell (fish is primary). direnv and zoxide hooks come from their
    # home-manager modules; nix is set up by /etc/zshenv (nix-darwin).
    initContent = lib.mkBefore ''
      # Java: Android Studio's bundled JDK when installed, else nix zulu21.
      jbr="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
      if [[ -d "$jbr" ]]; then
        export JAVA_HOME="$jbr"
      else
        export JAVA_HOME="${pkgs.zulu21.home}"
      fi
      export PATH="$JAVA_HOME/bin:$PATH"
      if [[ -d "$HOME/Library/Android/sdk" ]]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        export PATH="$ANDROID_HOME/platform-tools:$PATH"
      fi

      # shell foo bar -> nix shell nixpkgs#foo nixpkgs#bar
      shell() { nix shell "''${@/#/nixpkgs#}"; }

      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';
  };
}
