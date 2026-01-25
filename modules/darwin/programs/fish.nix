{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;
    shellInit = ''
      if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
      if test -f /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
      end

      # Setup editor
      set -x EDITOR "nvim"

      # Setup Homebrew
      eval (/opt/homebrew/bin/brew shellenv)

      fish_add_path ~/.local/bin
      fish_add_path ~/bin
      fish_add_path ~/Library/Python/3.9/bin/

      # Setup Java (prefer Homebrew JDK 17 if available, else fallback to Nix)
      set -l brew_java_home ""
      if type -q /usr/libexec/java_home
        set brew_java_home (/usr/libexec/java_home -v 17 2>/dev/null)
      end
      if test -n "$brew_java_home"
        set -x JAVA_HOME "$brew_java_home"
      else
        set -x JAVA_HOME "${pkgs.openjdk17}/libexec/openjdk"
      end
      fish_add_path $JAVA_HOME/bin

      # Zoxide (better cd)
      if command -v zoxide > /dev/null
        zoxide init fish | source
      end

      # Abbreviation: cd -> z (zoxide)
      abbr -a cd z
    '';
    functions = {
      fish_greeting = lib.mkDefault "";
      bind_bang = ''
        switch (commandline -t)
        case "!"
          commandline -t $history[1]; commandline -f repaint
        case "*"
          commandline -i !
        end
      '';
      bind_dollar = ''
        switch (commandline -t)
        case "!"
          commandline -t ""
          commandline -f history-token-search-backward
        case "*"
          commandline -i '$'
        end
      '';
      fish_user_key_bindings = ''
        bind ! bind_bang
        bind '$' bind_dollar
      '';
      hf = ''
        eval (history | fzf -i)
      '';
      shell = ''
        nix-shell --packages $argv
      '';
      nix-update = ''
        set -l current_dir (pwd)
        cd ~/repos/nix
        nix flake update && nix run .#build-switch
        cd $current_dir
      '';
      nix-apply-config = ''
        set -l current_dir (pwd)
        cd ~/repos/nix
        nix run .#build-switch-fast
        cd $current_dir
      '';
      nix-clean = ''
        set -l current_dir (pwd)
        cd ~/repos/nix
        nix-collect-garbage --delete-older-than 3d
        cd $current_dir
      '';
    };
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "a34b0c2809f665e854d6813dd4b052c1b32a32b4";
          sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
    ];
  };
}
