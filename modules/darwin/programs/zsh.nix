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

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      export EDITOR="vim"

      export JAVA_HOME="${pkgs.openjdk17}/libexec/openjdk";
      export PATH=$JAVA_HOME/bin:$PATH

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
