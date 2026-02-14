{
  config,
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
