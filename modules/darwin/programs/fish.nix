{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      rld = "source ~/.config/fish/config.fish";
      aliasList = "alias | bat --paging=never --wrap=never --language=fish";
      ding = "tput bel";

      ls = "eza --oneline --all --group-directories-first";
      ll = "eza --long --all --sort=modified --group-directories-first --header --smart-group --git --color=always --icons=always";
      tree = "eza --tree --all --icons=auto";

      "gc." = "git checkout .";
      gd = "git diff | bat --language diff";
      lg = "lazygit";
      gg = "lazygit";
      gs = "git status";

      vim = "nvim";
      v = "nvim";
      top = "btop";

      nix-config = "cursor ~/repos/nix";
      c = "cursor .";
    };
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

      # Setup Java
      set -x JAVA_HOME "${pkgs.openjdk17}/libexec/openjdk"
      fish_add_path $JAVA_HOME/bin
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
        nix flake update && nix run .#build-switch && nix-collect-garbage --delete-older-than 3d
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
