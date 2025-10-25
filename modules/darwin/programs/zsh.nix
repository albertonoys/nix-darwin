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

    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      export EDITOR="vim"

      # Prefer Homebrew JDK 17 when present; fallback to Nix openjdk17
      if command -v /usr/libexec/java_home >/dev/null 2>&1; then
        export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || echo "")
      fi
      if [ -z "$JAVA_HOME" ]; then
        export JAVA_HOME="${pkgs.openjdk17}/libexec/openjdk"
      fi
      export PATH="$JAVA_HOME/bin:$PATH"

      # direnv
      eval "$(direnv hook zsh)"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # ---- Zoxide (better cd) ----
      eval "$(zoxide init zsh)"

      # Zsh arrow key bindings
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward
    '';
  };
}
