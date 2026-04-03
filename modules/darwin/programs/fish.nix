{
  pkgs,
  lib,
  fish-tide,
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

      # pyenv
      if type -q pyenv
        set -Ux PYENV_ROOT $HOME/.pyenv
        fish_add_path $PYENV_ROOT/bin
        fish_add_path $PYENV_ROOT/shims
        pyenv init - | source
      end

      # Homebrew
      eval (/opt/homebrew/bin/brew shellenv)

      fish_add_path ~/.local/bin
      fish_add_path ~/bin

      # GitHub token for Nix flake updates (avoids API rate limits)
      # Set as NIX_CONFIG so only nix sees it, not git/gh
      if security find-generic-password -a nix-github-token -s nix-github-token &>/dev/null
        set -gx NIX_CONFIG "access-tokens = github.com="(security find-generic-password -a nix-github-token -s nix-github-token -w)
      end

      # Setup Java (prefer Android Studio bundled JDK, then system, then Nix)
      if test -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
        set -x JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
      else if type -q /usr/libexec/java_home
        set -l sys_java (/usr/libexec/java_home -v 17 2>/dev/null)
        if test -n "$sys_java"
          set -x JAVA_HOME "$sys_java"
        else
          set -x JAVA_HOME "${pkgs.openjdk17.home}"
        end
      else
        set -x JAVA_HOME "${pkgs.openjdk17.home}"
      end
      fish_add_path $JAVA_HOME/bin

      # Android SDK
      set -x ANDROID_HOME "$HOME/Library/Android/sdk"
      fish_add_path $ANDROID_HOME/platform-tools
      fish_add_path $ANDROID_HOME/tools

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
        fish -c "cd ~/repos/nix && just nix::update nix::switch"
      '';
      nix-apply-config = ''
        fish -c "cd ~/repos/nix && just nix::apply"
      '';
      nix-clean = ''
        fish -c "cd ~/repos/nix && just nix::gc"
      '';
      nix-upgrade = ''
        fish -c "cd ~/repos/nix && just nix::upgrade"
      '';
    };
    plugins = [
      {
        name = "tide";
        src = fish-tide;
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
